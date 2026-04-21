# IP Packet Fragmentation via Fragroute - CTF

**Capture file:** `fragroute_ctf.pcap`  

## Questions

---

**Q1.** What is the IP address of the host conducting the fragmentation attack?

> Apply `ip.flags.mf == 1 or ip.frag_offset > 0` to display all fragmented packets. Examine the **Source** column. You will see three distinct source IPs producing fragments: the attacker and two noise hosts running red-herring fragmentation. The attacker's IP appears repeatedly across six different IP Identification values (`0xBEEF` through `0xB00B`) in rapid succession - a pattern no legitimate host produces. The noise sources (10.30.40.20 and 10.30.40.21) each appear only once with a single IP ID. Cross-check by applying `ip.src == 10.30.40.77 and (ip.flags.mf == 1 or ip.frag_offset > 0)` to confirm all six attack chains share this source.

**10.30.40.77**

---

**Q2.** Apply `ip.id == 0xB00B`. What is the value of the **Fragment Offset** field (as displayed in Wireshark's packet detail pane, in units of 8 bytes) for the second fragment in this chain?

> Apply `ip.id == 0xB00B`. Three rows appear: two raw IPv4 fragment rows and Wireshark's reassembled ICMP row. Click the **second** raw fragment row (the middle one, labelled *Fragmented IP protocol* with a higher timestamp than the first). Expand **Internet Protocol Version 4 -> Flags**. Read the **Fragment Offset** field directly - Wireshark displays the raw field value in 8-byte units, not the byte position. Do not confuse this with the byte position (24); the answer is the field value itself. The byte position is field value × 8 = 3 × 8 = 24.

**3**

---

**Q3.** Using only the **Fragment Offset** field value and the **data length** of the final fragment in the `0xB00B` chain, calculate the total reassembled IP payload size in bytes. Show your working.

> Apply `ip.id == 0xB00B`. Click the final fragment (the one with **More Fragments: Not Set**, MF=0). In **Internet Protocol Version 4** read:
> - **Fragment Offset:** 6
> - **Total Length:** 44 -> IP header = 20 -> **data length = 44 − 20 = 24 bytes**

> Formula: `total_size = (fragment_offset × 8) + final_fragment_data_length`  
> Working: `(6 × 8) + 24 = 48 + 24 = 72`

Wireshark note: the reassembled ICMP row at the bottom of the filter results will also show **Reassembled IPv4 length: 72** in its packet tree, which you can use to verify your arithmetic.

**72 bytes**

---

**Q4.** Two fragmented packet chains in this capture originate from **non-attacker** hosts: IP ID `0x1234` (source 10.30.40.20) and IP ID `0x5678` (source 10.30.40.21). Which IP ID is associated with **fragmented UDP** traffic (proto=17), as opposed to fragmented ICMP?

> Apply `ip.id == 0x1234 or ip.id == 0x5678`. Four raw IPv4 fragment rows appear. Examine the **Info** column for each - Wireshark writes the encapsulated protocol into the fragment description, for example *Fragmented IP protocol (proto=TCP 6, ...)* or *proto=UDP 17* or *proto=ICMP 1*. One IP ID's fragments show `proto=ICMP 1` (a large ping from 10.30.40.20); the other shows `proto=UDP 17` (a large UDP datagram from 10.30.40.21). Read the `proto=` value in the Info column to distinguish them. Wireshark gotcha: the protocol field in the Info column reflects the IP **Protocol** field of the fragment, not a decoded transport header (there is no transport header to decode from a raw fragment).

**0x5678**

---

**Q5.** Apply `ip.id == 0xFACE`. How many individual packets (including any duplicates) make up this fragment storm chain? Count the rows directly in the packet list.

> Apply `ip.id == 0xFACE`. Count every row returned by this filter - Wireshark displays one row per raw packet. You will see five sequentially-offset fragments (offsets 0, 1, 2, 3, 4) plus one additional packet at offset 1 with different payload content (`CONFLICT` vs the original `CTFDATA2`). That sixth row is the duplicate. The last of the five ordered fragments (offset=4) has **More Fragments: Not Set** (MF=0), marking it as the intended final fragment. To verify the duplicate: click each offset=1 row in turn and compare the raw **Data** bytes in the packet bytes pane - they will differ.

**6**

---

**Q6.** In the overlapping fragment attack with IP ID `0xCAFE`, Fragment A (offset=0, data length=24 bytes) and Fragment B (offset=2, data length=32 bytes) overlap at a specific byte range within the reassembled datagram. State that byte range in the form "bytes X–Y".

> Apply `ip.id == 0xCAFE`. Two rows appear. For each fragment, expand **Internet Protocol Version 4** and note the **Fragment Offset** and **Total Length** fields. Then calculate the byte ranges each fragment occupies in the reassembled datagram:

> - Fragment A: offset=0, data len=24 -> covers **bytes 0–23**
> - Fragment B: offset=2 -> byte position = 2 × 8 = 16; data len=32 -> covers **bytes 16–47**

> The range covered by *both* is the intersection: bytes max(0,16) to min(23,47) = **bytes 16–23**. On a Linux or BSD host using last-writer-wins reassembly, Fragment B's 8-byte content at positions 16–23 overwrites Fragment A's content at the same positions. An IDS using first-writer-wins would see Fragment A's benign data (`GET /index.html HTTP/1.1`) at those bytes instead.

**bytes 16–23**

---

**Q7.** Apply `ip.id == 0xDEAD`. The two fragments in this out-of-order chain arrived in reversed order. What is the **Fragment Offset field value** of the fragment that arrived **first** on the wire (the one with the earlier timestamp)?

> Apply `ip.id == 0xDEAD`. Two rows appear. Examine the **Time** column - the earlier timestamp identifies which fragment arrived first on the wire. Click that first-arriving fragment and expand **Internet Protocol Version 4 -> Flags**. Read the **Fragment Offset** field value. You will notice this first-arriving fragment has **More Fragments: Not Set** (MF=0) even though it is not the start of the datagram - it is the tail end (higher byte offset) arriving before the head. This is the defining characteristic of out-of-order delivery: the receiver must buffer this fragment and wait for offset=0 to arrive before it can begin reassembly.

**2**

---

**Q8.** The fragmented attack chain with IP ID `0xACE0` carries a hidden HTTP request. After Wireshark reassembles the two fragments, what is the **HTTP Request-URI** shown in Wireshark's protocol decode?

> Apply `ip.id == 0xACE0`. Two rows appear: one raw IPv4 fragment row and one HTTP-decoded row. Click the HTTP row (the one labelled *POST /shell.php...* in the Info column). Expand **Hypertext Transfer Protocol** in the packet detail tree. Read the **Request URI** field directly. If Wireshark does not auto-decode the row as HTTP (this can happen if port 8080 is not in your HTTP port list), right-click the row -> **Decode As** -> set the destination port to **HTTP**. The full POST request becomes visible including the Host header `10.30.40.5` and `Content-Length: 4`. This is the payload that would have triggered an IDS command-injection signature if sent unfragmented.

**/shell.php**

---

**Q9.** What is the time gap in **milliseconds** between the first and second fragment of the tiny fragment attack chain (IP ID `0xBEEF`)?

> Apply `ip.id == 0xBEEF`. Two rows appear: the raw IPv4 first fragment and the reassembled TCP row (Wireshark merges the two raw fragments into one decoded TCP display row). To measure the gap, switch the **Time** column display to *Seconds Since Previous Displayed Packet*: View -> Time Display Format -> Seconds Since Previous Displayed Packet. The second row's Time value shows the elapsed time since the first row. Alternatively, click the first row, note its absolute timestamp; click the second row, note its timestamp; subtract. The gap is a clean value in milliseconds. Convert to ms by multiplying seconds by 1000. Wireshark gotcha: ensure you are reading the delta between the two `ip.id == 0xBEEF` rows, not a delta that includes intervening packets from other IP IDs.

**75**

---

**Q10.** The first fragment of IP ID `0xBEEF` has a data payload of exactly **8 bytes**, which contains only the TCP source port (2 bytes), destination port (2 bytes), and sequence number (4 bytes) - but **no TCP flags field**. What is the name of the Fragroute technique that deliberately produces this pattern, and which RFC first formally described the security concern it exploits?

> Apply `ip.id == 0xBEEF`. Click the first row (Protocol = IPv4, *Fragmented IP protocol*). Expand **Internet Protocol Version 4**: **Total Length = 28** (20-byte IP header + 8-byte data payload) and **Fragment Offset = 0**. Expand **Data** - exactly 8 raw bytes. There is no TCP layer to expand because 8 bytes are insufficient for Wireshark to decode the TCP header (the TCP flags byte sits at byte offset 13 of the TCP header, which lands in the second fragment). A stateless IDS inspecting only this fragment cannot determine the TCP flags, making port-based SYN-flood rules and flag-based signatures blind to this packet. The technique was first formally described as a security concern in **RFC 1858** (October 1995), *Security Considerations for IP Fragment Filtering*.

**Tiny Fragment Attack** (RFC 1858)
