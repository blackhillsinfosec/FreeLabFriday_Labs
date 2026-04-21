# ARP Cache Poisoning CTF

**Capture file:** `arp_poison_ctf.pcap`  

---

## Questions

---

**Q1. What is the IP address of the host performing the ARP cache poisoning attack?**

> The attacker's real IP address does not appear in any poisoning frame (those claim the gateway's or victim's IP). You need to find a different frame that reveals it.
>
> **Step 1 - Identify the attacker's MAC.** Apply:
> ```
> arp.opcode == 2
> ```
>
> **Step 2 - Find a frame where the attacker reveals its own IP.** At the very start of the trace the attacker sends a legitimate ARP request (before the attack begins). Apply:
> ```
> arp.opcode == 1 && eth.src == 02:de:ad:c0:ff:ee
> ```
> Select the result. In the packet detail pane, expand **Address Resolution Protocol**. Read the **Sender IP Address** field (`arp.src.proto_ipv4`). That is the attacker's real IP.

`10.20.30.200`

---

**Q2. What decimal ARP opcode number appears in the very first frame of the capture?**

> Clear all filters. Select frame 1 (the first row in the packet list). In the packet detail pane, expand **Address Resolution Protocol**. Read the **Opcode** field. Wireshark displays it as both a decimal number and a label - write the decimal number only.
>
> Note: do not confuse this with the Ethernet type (0x0806) or the hardware type (1). The opcode is the field that distinguishes a request from a reply.

`1`

---

**Q3. How many total ARP opcode-2 (reply) frames are present in the entire capture?**

> Apply the filter:
> ```
> arp.opcode == 2
> ```
> Read the packet count shown in the bottom status bar (e.g., "Displayed: X"). Count carefully - there are more reply frames than you might expect, because the trace contains legitimate replies, attacker-generated poison replies, **and** a red-herring gratuitous ARP from a third host claiming an IP address that appears nowhere else in the capture.

`12`

---

**Q4. How many distinct poisoning bursts does the attacker send?**

> A single "burst" is one coordinated pair of gratuitous ARP replies - one frame targeting the victim's cache and one targeting the gateway's cache - sent within milliseconds of each other. Count the number of such bursts, not the total number of attacker ARP frames.
>
> Apply:
> ```
> arp.opcode == 2 && eth.src == 02:de:ad:c0:ff:ee && arp.dst.hw_mac == 02:11:22:aa:bb:cc
> ```
> This filter isolates only the frames the attacker sends that target the **victim's** ARP cache (one per burst). The row count in the status bar equals the number of distinct bursts.
>
> Cross-check: the same count should result from:
> ```
> arp.opcode == 2 && eth.src == 02:de:ad:c0:ff:ee && arp.dst.hw_mac == 02:33:44:dd:ee:ff
> ```
> (frames targeting the gateway's cache - also one per burst).

`4`

---

**Q5. What is the time interval in seconds between consecutive poisoning bursts?**

> Using the filter from Q4:
> ```
> arp.opcode == 2 && eth.src == 02:de:ad:c0:ff:ee && arp.dst.hw_mac == 02:11:22:aa:bb:cc
> ```
> Read the **Time** column for all four results. Subtract consecutive timestamps to find the interval. All four intervals are identical - report that value as a whole number of seconds.

`3`

---

**Q6. What is the Ethernet destination MAC address of the first packet in which the victim's traffic is visibly intercepted by the attacker?**

> After the victim's ARP cache is poisoned, its kernel resolves the gateway IP (`10.20.30.1`) to the attacker's MAC. The Ethernet destination and IP destination then disagree - this is the ETH/IP divergence signature.
>
> Apply:
> ```
> ip.dst == 10.20.30.1 && eth.dst == 02:de:ad:c0:ff:ee
> ```
> Select the **first** result. In the packet detail pane:
> - Expand **Ethernet II**: `Destination` shows the attacker's MAC.
> - Expand **Internet Protocol**: `Destination Address` shows the gateway's IP (`10.20.30.1`).
>
> These two fields disagree - that is the definition of the divergence. Read the Ethernet `Destination` field exactly as Wireshark displays it, with colons.
>
> **Wireshark gotcha:** Wireshark may resolve the OUI prefix of this MAC to a vendor name. Right-click the Ethernet destination field -> **Copy -> Value** to get the raw colon-separated string.

`02:de:ad:c0:ff:ee`

---

**Q7. What username is encoded in the Authorization: Basic header of the intercepted HTTP request?**

> The victim sends an HTTP request containing a `Basic` authentication header while its traffic is being intercepted. Find it, then decode the credential string.
>
> **Step 1 - Locate the request.** Apply:
> ```
> http.request && ip.src == 10.20.30.4
> ```
> Select the result whose Info column shows `GET /admin.php`. In the packet detail pane, expand **Hypertext Transfer Protocol**. Expand the `Authorization` line. Wireshark displays the raw Base64 token.
>
> **Step 2 - Decode it.** The token follows `Authorization: Basic `. Copy it (right-click the field -> Copy -> Value). Decode from Base64 - the result is in `username:password` format. Report only the username (the part before the colon).
>
> You can decode in a terminal: `echo 'Y3RmdXNlcjpzM2NyM3Q=' | base64 -d`  
> or in Python: `import base64; base64.b64decode('Y3RmdXNlcjpzM2NyM3Q=').decode()`

`ctfuser`

---

**Q8. How many unique MAC addresses send at least one ARP opcode-2 frame in this capture?**

> Apply:
> ```
> arp.opcode == 2
> ```
>
> - The attacker sends multiple frames but they all share one MAC.
> - One host sends a **single** gratuitous ARP reply for IP address `10.20.30.250` - a host that does not appear anywhere else in the trace. This is a red herring: it is a benign gratuitous announcement, not a poisoning attempt. However, its source MAC **does** count toward the total of unique senders.
> - One additional host sends a single unicast reply in response to a legitimate ARP request earlier in the trace.

`4`


