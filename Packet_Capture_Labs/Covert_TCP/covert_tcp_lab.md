# CovertTCP - IP Identification Covert Channel

**Capture file:** `covert_tcp_lab.pcap`

---

## Topology

| Role | IP Address | MAC Address | Notes |
|------|-----------|-------------|-------|
| Sender (covert encoder) | 10.1.1.10 | 00:AA:BB:CC:DD:01 | Encodes secret data in outbound IPID fields |
| Receiver (covert decoder) | 10.1.1.20 | 00:AA:BB:CC:DD:02 | Reconstructs message from received IPID values |
| Default Gateway | 10.1.1.1 | 00:AA:BB:CC:DD:00 | Transit for DNS, NTP, and syslog traffic |

---

## Part 1 - The IP Identification Field

### Background

The IPv4 header is 20 bytes long (absent options). **Bytes 4–5** (big-endian, counting from 0 at the start of the IP header) carry the **Identification** field - a 16-bit unsigned integer defined in RFC 791. Its designed purpose is fragmentation reassembly: when a datagram is too large for a link's MTU and must be split, every fragment of the same original datagram carries the same Identification value so the destination can group and reassemble them. The Flags field (bit 2 = More Fragments) and the Fragment Offset field work alongside it

In practice, fragmentation is rare on modern networks, which rely on Path MTU Discovery (RFC 1191) to size datagrams appropriately. Because the field is no longer fulfilling its original role on most flows, operating systems have treated its assignment differently over time. Linux kernels before 3.x incremented a single global counter per outbound packet, producing a predictable monotone sequence visible to any observer. Later kernels switched to per-destination counters and eventually to pseudo-random values per RFC 6864. Windows NT-family hosts similarly incremented a global counter. The result is that IPID behaviour varies widely: a capture showing neither increment-by-one nor random values is a strong anomaly indicator

**CovertTCP** (Rowland, 1996) repurposes this field as a covert data channel. The sender assigns the Identification field of each outgoing packet to the decimal ASCII value of the character it wishes to transmit, then sends a plausible-looking packet to the receiver. The receiver reads each arriving packet's `ip.id` field in sequence, converts each value to the corresponding ASCII character, and reconstructs the hidden string. One packet carries one character; a 6-character message requires exactly 6 packets. Because the secret is stored in the IP header - not the TCP payload - standard payload-inspection defences see nothing suspicious in the data stream itself

### Steps

1. **Open the capture.** In Wireshark, go to **File -> Open** and load `covert_tcp_lab.pcap`. The packet list should show 64 frames with no red rows

2. **Navigate to frame 34** (first covert data packet) by pressing **Ctrl+G** (Go To Packet) and entering `34`

3. **Expand the IP header.** In the packet-detail pane, click the arrow next to **Internet Protocol Version 4**. The fields appear in this order, matching the wire layout:

```
Version: 4
Header Length: 20 bytes (5)
Differentiated Services Field: 0x00
Total Length: 58
Identification: 0x0053 (83)          <- bytes 4–5 of the IP header
Flags: 0x2, Don't Fragment
Fragment Offset: 0
Time to Live: 64
Protocol: TCP (6)
Header Checksum: 0x.... [correct]
Source Address: 10.1.1.10
Destination Address: 10.1.1.20
```

4. **Locate the Identification bytes in the hex pane.** The hex dump below the detail pane highlights the field. After the 14-byte Ethernet header, the IP header begins at byte 14. Bytes 18–19 of the full frame (offset 4–5 within the IP header) read `00 53` in big-endian - decimal 83 - the ASCII code for `S`

5. **Add an IPID column for easy reading.** Right-click the **Identification** line in the detail pane -> **Apply as Column**. A new column named `Identification` appears in the packet list. You can now scan all IPID values at a glance without expanding the IP layer for each packet

6. **Check the fragmentation fields.** Note that **Flags** shows `0x2` (Don't Fragment set; More Fragments Not set) and **Fragment Offset** is 0 for every packet. The sender has explicitly disabled fragmentation. The Identification field is not being used for its designed purpose on any packet in this capture

---

## Part 2 - The Covert Channel in Action

### Background

To communicate covertly, the sender loads the ASCII decimal value of each character of the secret message directly into the IPv4 Identification field, then dispatches a packet toward the receiver. The cover payload is a syntactically valid HTTP GET request so that the TCP stream looks like web traffic to any tool reading only application-layer content. The receiver ignores the HTTP payload and reads only the `ip.id` field of each arriving packet from the sender, assembling characters in arrival order

The complete covert message in this capture is **SECRET**. The six characters map to IPID values as follows:

| Char | ASCII dec | IPID (hex) | Frame |
|------|-----------|------------|-------|
| S | 83 | 0x0053 | 34 |
| E | 69 | 0x0045 | 36 |
| C | 67 | 0x0043 | 38 |
| R | 82 | 0x0052 | 40 |
| E | 69 | 0x0045 | 42 |
| T | 84 | 0x0054 | 44 |

Because every printable ASCII character has a decimal value ≤ 126 (0x7E), all six IPID values fit in the bottom 7 bits of the 16-bit field. The upper byte is zero in every case, which is itself an anomaly a defender can query for

### Steps

1. **Filter to the covert sender's traffic.** Apply the filter:

```
ip.src == 10.1.1.10 and tcp.dstport == 80
```

The packet list shows **10 rows**: the SYN (frame 31), the ACK completing the handshake (frame 33), the 6 data packets (frames 34, 36, 38, 40, 42, 44), the FIN-ACK (frame 46), and the final teardown ACK (frame 48).

2. **Isolate only the data packets** by adding a PSH flag constraint:

```
ip.src == 10.1.1.10 and tcp.dstport == 80 and tcp.flags.push == 1
```

This returns exactly **6 rows** - the six covert data packets

3. **Read the IPID values in sequence.** In your `ip.id` column (added in Part 1, Step 5), read top to bottom:

```
0x0053   0x0045   0x0043   0x0052   0x0045   0x0054
```

4. **Convert each IPID to its ASCII character.** Use the ASCII table from the end of this lab file. Working across:

- `0x53` = 83 -> **S**
- `0x45` = 69 -> **E**
- `0x43` = 67 -> **C**
- `0x52` = 82 -> **R**
- `0x45` = 69 -> **E**
- `0x54` = 84 -> **T**

5. **Assemble the string.** Read the characters in frame-number order: **SECRET**.

6. **Verify in the hex pane.** Click frame 38 (IPID=0x0043 = 'C'). In the hex dump, find bytes 18–19 of the frame (bytes 4–5 of the IP header): they read `00 43`. In the detail pane, **Internet Protocol Version 4 -> Identification** confirms `0x0043 (67)`.

---

## Part 3 - The Cover Traffic

### Background

A covert channel is only useful if it survives casual inspection. CovertTCP achieves this by wrapping the covert signalling inside a legitimate-looking TCP connection to a plausible destination port (port 80, typically associated with HTTP). Each data packet carries a syntactically correct HTTP GET request as its TCP payload, so any analyst dumping `strings` on the payload or watching a proxy log sees ordinary web traffic. The secret travels in the IP header, a layer that most application-layer monitoring tools never inspect.

The cover design has a deliberate mismatch: a real HTTP client would send one GET and wait for a response before sending another. Here the sender fires a new GET with each character, and the receiver sends back only bare ACKs - no HTTP response body appears in the TCP stream. This oddity is a secondary detection indicator (see Part 4), but it is invisible to tools that only log completed HTTP transactions.

### Steps

1. **Examine the TCP payload of a covert data packet.** Click frame 34. In the packet-detail pane, expand **Transmission Control Protocol -> [TCP payload]** or look at the hex pane. The payload reads:

```
GET / HTTP/1.0\r\n\r\n
```

This is 18 bytes of syntactically valid HTTP. A payload-inspection tool flags nothing.

2. **Check the receiver's responses.** Apply the filter:

```
ip.src == 10.1.1.20 and tcp.srcport == 80
```

The 8 rows returned include the SYN-ACK (frame 32), 6 bare ACKs (frames 35, 37, 39, 41, 43, 45), and the FIN-ACK (frame 47). **The receiver never sends any HTTP response body.** Expand the TCP layer on frame 35: it carries zero bytes of application data - flags show only ACK.

3. **Compare with the legitimate background HTTP stream.** Apply:

```
tcp.port == 8080
```

Frame 20 carries a `GET /status HTTP/1.0` request and frame 21 carries a full `HTTP/1.0 200 OK` response with a body. This is how a real HTTP exchange looks: request followed by a response with content. The covert stream on port 80 has requests but no substantive responses - the asymmetry is detectable.

4. **Confirm the IPID is not in the payload.** With frame 34 selected, look at the raw hex below. The bytes that encode `GET / HTTP/1.0\r\n\r\n` begin well after the IP Identification field. The TCP payload contains `47 45 54 20 2F 20 48 54 54 50 2F 31 2E 30 0D 0A 0D 0A` - none of which is 0x53 ('S'). The secret character exists **only** at IP header offset 4–5.

---

## Part 4 - Detection Indicators

### Background

CovertTCP produces a constellation of anomalies in a packet capture, each individually weak but collectively conclusive. A trained analyst hunting for IP-layer covert channels applies several complementary filters.

**Indicator 1 - IPID values in the printable ASCII range.** Normal operating systems assign IPID values that are either incrementing (starting anywhere and wrapping at 65535) or pseudo-random across the full 0x0000–0xFFFF range. A long sequence of IPID values in the narrow window 0x0020–0x007E is statistically implausible in legitimate traffic and immediately suspicious.

**Indicator 2 - Non-sequential, non-random IPID pattern.** CovertTCP's IPIDs are determined by the message, not by any counter or PRNG. Two identical characters in succession (e.g., the two 'E's in SECRET) produce the same IPID twice in a row - something a counter never does and a good PRNG does only with negligible probability.

**Indicator 3 - IPID sequence decodes to intelligible text.** If you write down the IPID values in order and look up their ASCII equivalents, you get a recognisable English word or phrase.

**Indicator 4 - Payload content does not match IPID content.** The TCP payload carries generic HTTP GETs with no meaningful variation across packets. The only variation is in the IP header. This mismatch is the fingerprint of header-layer steganography.

**Indicator 5 - Repeated identical requests with no HTTP responses.** Legitimate HTTP clients do not send the same GET request six times in a row without ever receiving a response body. The receiver's bare ACKs reveal that no real web server is listening.

### Steps

1. **Hunt for IPID values in the printable ASCII range from the sender.** Apply:

```
ip.src == 10.1.1.10 and ip.id >= 0x0020 and ip.id <= 0x007e
```

The filter returns **6 rows** - exactly the 6 covert data packets and nothing else from this sender. All background noise packets from 10.1.1.10 have IPID values well outside this window.

2. **Look for repeated IPID values within the stream.** Apply:

```
ip.src == 10.1.1.10 and tcp.dstport == 80 and tcp.flags.push == 1
```

Sort by the `ip.id` column. You will see `0x0045` appearing **twice** (frames 36 and 42). An incrementing counter would never repeat; a real PRNG repeating a value this quickly in a 6-packet sequence is anomalous.

3. **Attempt a decode from the Wireshark display.** With the `ip.id` column visible and the filter from Step 2 active, read the 6 IPID values top to bottom (sorted by frame number, not by value): `53 45 43 52 45 54`. Open a calculator or mental ASCII table: 0x53=S, 0x45=E, 0x43=C, 0x52=R, 0x45=E, 0x54=T -> **SECRET**. The sequence decodes to an English word.

4. **Cross-check payload content.** With frame 34 selected, expand **Hypertext Transfer Protocol**. Wireshark shows the request line `GET / HTTP/1.0\r\n`. Click frame 36 - identical payload. All 6 covert packets carry bit-for-bit identical HTTP payloads. No normal HTTP client generates this pattern.

5. **Verify the missing HTTP responses.** Apply:

```
ip.src == 10.1.1.20 and tcp.srcport == 80 and tcp.len > 0
```

This asks: did the receiver ever send a TCP segment with actual payload data back to the sender on port 80? The result is 0 rows. Every packet the receiver sent on this stream was a bare ACK (zero payload bytes). A functioning web server would have sent at least one response body. The complete absence of data from the receiver is the clearest evidence that no real HTTP service was running - the port 80 session is a hollow cover.

---

## Part 5 - Countermeasures and Variations

### Background

The CovertTCP IPID technique depends on two preconditions: the sender controls the IPID value of outgoing packets at the raw-socket level, and the IPID field is preserved end-to-end between sender and receiver. Both conditions are attackable by defenders.

**IPID randomisation** is the most effective countermeasure. RFC 6864 (2013) explicitly calls for hosts to assign pseudo-random IPID values for atomic (non-fragmented) datagrams, which describes virtually all modern traffic. Linux kernels since approximately 3.x generate a random IPID per packet for non-fragmented traffic. Windows Vista and later do the same. A packet capture from a modern host shows IPID values uniformly distributed across 0x0000–0xFFFF with no discernible pattern. An attacker cannot encode an ASCII character in a random field because the OS overwrites the intended value before transmission.

**Middlebox normalisation** provides a second layer of defence. Some stateful firewalls and IDS appliances - notably Snort/Suricata with IP defragmentation normalisation enabled - rewrite the Identification field of all non-fragmented packets to a sequential counter or to zero, destroying any covert data in transit. The receiver reconstructs the stream but reads only the normalised values, not the original.

**Detection via IDS rules** is feasible once the pattern is known. A Snort-style rule that flags any host sending more than four consecutive IP packets with IPID values in the printable ASCII range (0x20–0x7E) to the same destination port provides high-fidelity detection with low false-positive rates on modern networks where IPID values should be random.

**Alternative covert channels** target other header fields that operators may overlook:

- **TTL covert channel:** Encode data in the TTL field of outgoing packets. Because TTL is decremented at each hop, sender and receiver must agree on the hop count in advance or use it only on a single-hop LAN segment.
- **TCP Initial Sequence Number (ISN):** Pack data into the 32-bit ISN of each new TCP SYN. One SYN carries 4 bytes of covert data. Detection: anomalous SYN floods or a sequence of connections whose ISNs decode to printable ASCII.
- **TCP Timestamp low byte:** RFC 7323 timestamps increment monotonically. The sender can bias the low-order byte of each timestamp to the desired ASCII value. More subtle than IPID - timestamps are normally large and the manipulation is a small deviation.
- **DNS subdomain encoding:** Encode data as base32 subdomains in DNS queries. Not an IP-header channel but another covert exfiltration path that evades payload inspection of non-DNS traffic.

### Steps

1. **Observe what randomised IPIDs look like in the background traffic.** Apply:

```
ip.src == 10.1.1.10 and not tcp.dstport == 80 and ip.proto == 1
```

The ICMP packets from the sender (frames 9, 11, 29) have IPID values 0x2001, 0x2003, 0x2005 - a low incrementing sequence simulating an OS counter that is clearly distinct from the covert ASCII values. On a fully patched modern Linux host, these would instead be random 16-bit values.

2. **Write a targeted detection filter.** The following filter flags TCP packets from any single host to port 80 where the IPID is in the printable ASCII range:

```
tcp.dstport == 80 and ip.id >= 0x0020 and ip.id <= 0x007e
```

Apply this filter. It returns **6 rows** - all 6 covert data packets - and no false positives from background traffic in this capture.

3. **Check the background TCP stream's IPID values.** Apply:

```
tcp.port == 8080
```

The background stream (receiver->sender:8080, frames 17–24) has IPID values 0x6001–0x6008 - incrementing counter, no printable ASCII range overlap. A real noisy network would show random IPIDs here.

4. **Consider the TTL variation.** Expand **Internet Protocol Version 4** on any covert data packet. **Time to Live** is 64 - a round number that is the Linux default, normal and unremarkable. If a TTL-based channel were in use, you would apply:

```
ip.src == 10.1.1.10 and ip.ttl >= 32 and ip.ttl <= 126
```

to hunt for TTL values in a data-bearing range. In this capture no TTL manipulation is present.

5. **Understand the defender's position.** The most robust defence is not detection but prevention: deploy network equipment that normalises (randomises or zeros) the IPID field on all non-fragmented egress traffic. Combined with a firewall rule blocking raw-socket access for non-root users, this removes the preconditions for the attack at the infrastructure level rather than relying on signature-based detection of the specific ASCII-range pattern.

---

## Quick Reference - Wireshark Filters

| Purpose | Filter |
|---------|--------|
| All traffic from covert sender | `ip.src == 10.1.1.10` |
| Covert session only (both directions) | `tcp.stream eq 2` |
| Covert sender -> port 80 | `ip.src == 10.1.1.10 and tcp.dstport == 80` |
| Covert data packets only (PSH+ACK) | `ip.src == 10.1.1.10 and tcp.dstport == 80 and tcp.flags.push == 1` |
| IPID values in printable ASCII range | `ip.id >= 0x0020 and ip.id <= 0x007e` |
| IPID printable ASCII from sender only | `ip.src == 10.1.1.10 and ip.id >= 0x0020 and ip.id <= 0x007e` |
| TCP SYN packets | `tcp.flags.syn == 1 and tcp.flags.ack == 0` |
| TCP SYN-ACK packets | `tcp.flags.syn == 1 and tcp.flags.ack == 1` |
| TCP FIN packets | `tcp.flags.fin == 1` |
| Background stream (port 8080) | `tcp.port == 8080` |
| ARP frames only | `arp` |
| DNS traffic | `dns` |
| NTP traffic | `udp.port == 123` |
| ICMP echo requests | `icmp.type == 8` |
| mDNS traffic | `udp.port == 5353` |
| UDP syslog | `udp.dport == 514` |
| Follow covert session stream | Right-click covert pkt -> Follow -> TCP Stream |

---

### ASCII Diagram

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|Version|  IHL  |    DSCP/ECN   |          Total Length         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|        Identification         |Flags|      Fragment Offset    |
|     ^^^^ COVERT DATA ^^^^     |                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Time to Live |    Protocol   |        Header Checksum        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                       Source Address                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Destination Address                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Options (if IHL > 5)                   ... |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

The Identification field occupies bits 16–31 of the first 32-bit word in the second row - byte offsets 4 and 5 from the start of the IP header. In Wireshark's hex pane, these appear as bytes 18–19 of the full Ethernet frame (after 14 bytes of Ethernet header)

---

## ASCII Printable Range Table and Key Constants

### Printable ASCII (0x20–0x7E)

```
Dec  Hex  Chr  |  Dec  Hex  Chr  |  Dec  Hex  Chr  |  Dec  Hex  Chr
 32  0x20  SPC |   56  0x38   8  |   80  0x50   P  |  104  0x68   h
 33  0x21   !  |   57  0x39   9  |   81  0x51   Q  |  105  0x69   i
 34  0x22   "  |   58  0x3A   :  |   82  0x52   R  |  106  0x6A   j
 35  0x23   #  |   59  0x3B   ;  |   83  0x53   S  |  107  0x6B   k
 36  0x24   $  |   60  0x3C   <  |   84  0x54   T  |  108  0x6C   l
 37  0x25   %  |   61  0x3D   =  |   85  0x55   U  |  109  0x6D   m
 38  0x26   &  |   62  0x3E   >  |   86  0x56   V  |  110  0x6E   n
 39  0x27   '  |   63  0x3F   ?  |   87  0x57   W  |  111  0x6F   o
 40  0x28   (  |   64  0x40   @  |   88  0x58   X  |  112  0x70   p
 41  0x29   )  |   65  0x41   A  |   89  0x59   Y  |  113  0x71   q
 42  0x2A   *  |   66  0x42   B  |   90  0x5A   Z  |  114  0x72   r
 43  0x2B   +  |   67  0x43   C  |   91  0x5B   [  |  115  0x73   s
 44  0x2C   ,  |   68  0x44   D  |   92  0x5C   \  |  116  0x74   t
 45  0x2D   -  |   69  0x45   E  |   93  0x5D   ]  |  117  0x75   u
 46  0x2E   .  |   70  0x46   F  |   94  0x5E   ^  |  118  0x76   v
 47  0x2F   /  |   71  0x47   G  |   95  0x5F   _  |  119  0x77   w
 48  0x30   0  |   72  0x48   H  |   96  0x60   `  |  120  0x78   x
 49  0x31   1  |   73  0x49   I  |   97  0x61   a  |  121  0x79   y
 50  0x32   2  |   74  0x4A   J  |   98  0x62   b  |  122  0x7A   z
 51  0x33   3  |   75  0x4B   K  |   99  0x63   c  |  123  0x7B   {
 52  0x34   4  |   76  0x4C   L  |  100  0x64   d  |  124  0x7C   |
 53  0x35   5  |   77  0x4D   M  |  101  0x65   e  |  125  0x7D   }
 54  0x36   6  |   78  0x4E   N  |  102  0x66   f  |  126  0x7E   ~
 55  0x37   7  |   79  0x4F   O  |  103  0x67   g  |
```

**Characters used in this capture's covert message (SECRET):**

| Char | Decimal | Hex |
|------|---------|-----|
| S | 83 | 0x53 |
| E | 69 | 0x45 |
| C | 67 | 0x43 |
| R | 82 | 0x52 |
| T | 84 | 0x54 |
