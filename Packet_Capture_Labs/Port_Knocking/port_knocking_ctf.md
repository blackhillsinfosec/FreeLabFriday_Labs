# Port Knocking CTF - Questions & Answers

**Capture file:** `port_knocking_ctf.pcap`

---

**Q1. What is the IP address of the protected server?**

> Filter `tcp.flags.reset == 1` and look at the Source column - every RST on the knock ports comes from the same host. Cross-check with `ip.dst` on the SYN packets that never get a SYN-ACK back. The server is the only host that RSTs connections on multiple high-numbered ports while also eventually completing a TCP handshake on port 22.

`172.16.200.1`

---

**Q2. What are the three knock ports, and in what order were they used to successfully open the firewall?**

> Filter `ip.dst == 172.16.200.1 && tcp.flags.syn == 1 && tcp.flags.ack == 0` and sort by time. Identify the source IP that successfully reaches an SSH session afterward - that is your valid client. Read its destination ports in chronological order, skipping port 22 itself (which comes after the sequence is complete). The attacker visits ports in a different order and never gets through; use that as a negative check on your sequence.

`4000 -> 5000 -> 6000`

---

**Q3. What is the source port used for the third and final knock SYN?**

> Filter `ip.src == 10.13.37.9 && tcp.dstport == 6000 && tcp.flags.syn == 1`. There is exactly one matching packet. Click it, expand **Transmission Control Protocol**, and read the **Source Port** field. Notice that the valid client increments its ephemeral port by one for each new knock socket: 62343, 62344, 62345 - a small detail that confirms the knocks were scripted rather than sent manually.

`62345`

---

**Q4. What is the TCP Sequence Number (raw hex) of the very first knock SYN?**

> Filter `tcp.dstport == 4000 && tcp.flags.syn == 1 && ip.src == 10.13.37.9`. Click the result, expand **Transmission Control Protocol**, and read the **Sequence Number (raw)** field. Note that Wireshark displays relative sequence numbers by default - you must read the *raw* value. Either disable relative sequence numbers globally via `Edit -> Preferences -> Protocols -> TCP -> uncheck "Relative sequence numbers"`, or right-click the Sequence Number field in the detail pane and choose **Value**.

`0xcafebabe`

---

**Q5. How many packets does the failing attacker (203.0.113.77) send to the server in total?**

> Filter `ip.src == 203.0.113.77 && ip.dst == 172.16.200.1` and count the results. All four are SYN packets - three knock attempts (ports 4000, 6000, 5000 in that order) and a final SSH attempt on port 22. Every single one is RST'd because the knock order 4000->6000->5000 is wrong; the firewall expects 4000->5000->6000. The gate never opens for this IP.

`4`

---

**Q6. What is the server's raw Initial Sequence Number (hex) in the SSH SYN-ACK?**

> Filter `tcp.srcport == 22 && tcp.flags == 0x012`. There is exactly one SYN-ACK in the capture. Click it, expand **Transmission Control Protocol**, and read **Sequence Number (raw)**. This is the server's ISN - it was chosen before any application data was exchanged and appears only in this one packet. All subsequent server-side sequence numbers are this value plus cumulative payload lengths.

`0xdeadc0de`

---

**Q7. What DNS resolver handled all queries in this capture, and how many unique domain names were queried across all DNS traffic?**

> Filter `udp.port == 53` and look at the Destination column for the query packets (those with source port ≠ 53). All queries go to the same server. To enumerate unique names, either expand the DNS layer on each query packet and read the **Queries -> Name** field, or use `Statistics -> Resolved Addresses` to list all DNS names seen. Count carefully - some names resolve to RFC 1918 addresses and may look like internal noise rather than real lookups.

`1.1.1.1` - **6 unique domains:** `metrics.telemetry.io`, `apt.corp.internal`, `updates.pkg.internal`, `api.github.com`, `prod.svc.cluster.local`, `cdn.cloudfront.net`

---

**Q8. What is the interval in milliseconds between each consecutive knock sent by the valid client? Are both gaps the same?**

> Filter `ip.src == 10.13.37.9 && tcp.flags.syn == 1 && (tcp.dstport == 4000 || tcp.dstport == 5000 || tcp.dstport == 6000)`. Set `View -> Time Display Format -> Seconds Since Previous Displayed Packet`. The Time column will show the gap between each consecutive knock directly. Both inter-knock gaps are identical - a signature of a scripted knockd client using a fixed `delay` setting rather than a human typing commands.

`750 ms` - both gaps (K1->K2 and K2->K3) are exactly 750 ms

---

**Q9. What is the full SSH server version banner string?**

> Filter `tcp.port == 22 && tcp.flags.push == 1`. The first PSH-flagged packet on port 22 is the server sending its identification string in plaintext - SSH exchanges version banners before any encryption is negotiated. Click the packet, expand **Transmission Control Protocol -> TCP payload**, and read the ASCII text. Alternatively, right-click any port-22 packet -> `Follow -> TCP Stream`; the banner appears as the first line of the stream in the server's colour.

`SSH-2.0-OpenSSH_9.3p1 Ubuntu-1ubuntu3.6`

---

**Q10. A non-knock, non-SSH UDP service on the server received traffic from the valid client during this capture. What destination port did it use, and how many times was it contacted?**

> Apply `ip.dst == 172.16.200.1 && udp` - this isolates all UDP traffic *arriving at the server*. You should find packets destined for a port that is not 53 and not 123. Note how close this port number is to the first knock port: the proximity is intentional telemetry traffic, not a knock. Count the matching packets. This type of traffic is a common distractor in port-knocking captures - analysts who scan for "all traffic to the server on high ports" will encounter it and may initially miscount the knock sequence length.

Port `4001` - contacted `3` times (UDP beacons at t≈0.200 s, t≈0.600 s, and t≈1.400 s)
