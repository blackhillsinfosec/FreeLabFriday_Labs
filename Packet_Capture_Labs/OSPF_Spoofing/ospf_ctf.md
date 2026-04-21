# OSPF Packet Analysis CTF

**Capture file:** `ospf_ctf.pcap`

## Questions

---

**Q1. What is the Router-ID advertised in the attacker's spoofed LS Update packet?**

> The attacker's Router-ID is placed in two locations inside the LSU: the OSPF header's Source OSPF Router field, and the Advertising Router field of the LSA inside the packet. Find one of the attacker's LSU frames and read either field.
>
> **Step 1 - Isolate OSPF traffic.** The attacker's source IP does not appear in any Hello before the attack window (t ≈ 55–57 s). Apply:
> ```
> ip.proto == 89
> ```
> Scroll to t ≈ 56–57 s. You will see two LSU packets from a source IP that never appeared before.
>
> **Step 2 - Read the Router-ID.** Click either attacker LSU. In the packet detail pane, expand **Open Shortest Path First -> OSPF Header**. Read the `Source OSPF Router` field.

`10.20.30.77`

---

**Q2. What is the exact value of the LS Age field in the MaxAge LSA injected by the attacker?**

> The OSPF MaxAge constant is 3600 seconds. An LSA carrying this age is immediately flushed from every router's LSDB. Find the attacker's MaxAge LSU and read the field directly.
>
> **Step 1 - Filter for MaxAge LSAs.** Apply:
> ```
> ospf.lsa.age == 3600
> ```
> One packet appears.
>
> **Step 2 - Read the LS Age.** Click the result. Expand **Open Shortest Path First -> LS Update Packet**. Expand the LSA listed inside. The first field of the LSA header is displayed as:
> ```
> .000 0000 0000 1110 0001 0000 = LS Age (seconds): 3600
> ```
> Read the decimal value.

`3600`

---

**Q3. What OSPF packet type number did the attacker use for their first malicious packet?**

> The attacker's first packet is not an LSU - it is a different packet type designed to disrupt an existing adjacency. Identify it by its OSPF Message Type field.
>
> **Step 1 - Isolate attacker packets.** Apply:
> ```
> ip.src == 10.20.30.77 and ip.proto == 89
> ```
> Three packets appear sorted by time - the first is the earliest.
>
> **Step 2 - Read the type.** Click the first result (lowest timestamp). Expand **Open Shortest Path First -> OSPF Header**. Read the `Message Type` field. Wireshark displays it as both a number and a label - report the number only.
>
> Note: also observe the `Router Dead Interval` field in the Hello body - it reads 80, while every legitimate Hello in this capture uses 40. This mismatch is what makes the packet malicious.

`1`

---

**Q4. What is the OSPF Area ID shown in the Hello packets sent by the legitimate routers?**

> The Area ID is a 32-bit field in every OSPF packet header, encoded as a dotted-quad. All routers on the same segment must agree on it.
>
> **Step 1 - Filter for Hello packets.** Apply:
> ```
> ospf.msg == 1
> ```
>
> **Step 2 - Read the Area ID.** Click any Hello from `10.20.30.1`, `10.20.30.2`, or `10.20.30.3` before t = 55 s. Expand **Open Shortest Path First -> OSPF Header**. Read the `Area ID` field. Wireshark appends a label in parentheses - report only the dotted-quad value.

`0.0.0.0`

---

**Q5. What is the destination network prefix injected by the attacker's fake Summary-LSA?**

> The attacker's second LSU carries a Summary-LSA (type 3) advertising a route to a non-existent network. The destination prefix is stored in the Link State ID field of the LSA header.
>
> **Step 1 - Find the fake Summary-LSA.** Apply:
> ```
> ip.src == 10.20.30.77 and ospf.msg == 4
> ```
> Two LSU packets appear. The first (t ≈ 56 s) carries the MaxAge LSA. The second (t ≈ 57 s) carries the fake Summary-LSA.
>
> **Step 2 - Read the prefix.** Click the second result. Expand **Open Shortest Path First -> LS Update Packet**. Expand the LSA. Read the `Link State ID` field - that is the network address. Expand the LSA body and confirm `Network Mask: 255.255.255.0` to establish the prefix length.
>
> Also observe the `Advertising Router` field - it is spoofed as `10.20.30.1` (R1, the DR) to make the LSA appear credible.

`10.99.88.0/24`

---

**Q6. How many LSAck packets did legitimate routers send in response to the attacker's MaxAge LSU?**

> When a router receives an LSU it must acknowledge it with an LSAck. Count only the LSAcks sent by legitimate routers in the one-second window immediately following the MaxAge LSU.
>
> **Step 1 - Note the MaxAge LSU timestamp.** Apply `ospf.lsa.age == 3600` - note the time (t ≈ 56 s).
>
> **Step 2 - Count the LSAcks.** Apply:
> ```
> ospf.msg == 5 and frame.time_relative >= 56 and frame.time_relative < 57
> ```
> Read the packet count in the bottom status bar.
>
> **Step 3 - Verify.** Click each result and expand **Open Shortest Path First -> LS Acknowledge Packet**. Confirm the 20-byte LSA header inside references the MaxAge LSA (Link State ID `10.20.30.3`, Seq `0x80000001`).

`2`

---

**Q7. What is the numeric Auth Type value in a Hello packet sent by R1 using null authentication?**

> The Auth Type field is a 16-bit value in every OSPF header. Type 0 means no authentication is performed - any host on the segment can inject packets without credentials. This is what enables all three attacks in this capture.
>
> **Step 1 - Find a pre-attack Hello from R1.** Apply:
> ```
> ospf.msg == 1
> ```
> Click any Hello from source IP `10.20.30.1` before t = 55 s.
>
> **Step 2 - Read the Auth Type.** Expand **Open Shortest Path First -> OSPF Header**. Read the `Auth Type` field. Wireshark displays it as both a number and a label (e.g. `Null (0)`) - report the number only.
>
> Also observe the `Auth Data (none): 0000000000000000` field immediately below - eight zero bytes confirming no credential is present.

`0`

---

**Q8. What is the IP address of the Designated Router as shown in the DR field of a steady-state Hello packet?**

> The Designated Router (DR) is elected on a broadcast segment to manage LSA flooding. Its IP address is carried in every Hello's Designated Router field once election is complete.
>
> **Step 1 - Find a steady-state Hello.** Apply:
> ```
> ospf.msg == 1
> ```
> Click any Hello in the range t = 17–45 s (after adjacency formation, before the attack).
>
> **Step 2 - Read the DR field.** Expand **Open Shortest Path First -> Hello Packet**. Read the `Designated Router` field.
>
> Note: also observe the `Backup Designated Router` field - it will show a different IP, identifying the BDR.

`10.20.30.1`

---

**Q9. How many seconds elapsed between the attacker's first malicious packet and R1's first re-flood LSU in response?**

> R1 detects the MaxAge injection and re-floods correct LSAs to restore the LSDB. Measure the gap between the attacker's first packet and R1's recovery LSU.
>
> **Step 1 - Record the attack start time.** Apply:
> ```
> ip.src == 10.20.30.77 and ip.proto == 89
> ```
> Click the first result. Read the time from the Time column - note it in seconds.
>
> **Step 2 - Record R1's re-flood time.** Apply:
> ```
> ip.src == 10.20.30.1 and ospf.msg == 4 and frame.time_relative >= 62
> ```
> Click the result. Read its time.
>
> **Step 3 - Subtract.** Report the difference as a whole number of seconds.

`8`

---

**Q10. What is the LS Sequence Number of the attacker's injected fake Summary-LSA?**

> The LS Sequence Number is a 32-bit monotonically increasing value inside each LSA header. The initial value for any newly originated LSA is always `0x80000001`. An unusually high value on a freshly injected LSA is itself a detection indicator - the attacker chose a high sequence number to prevent legitimate routers from superseding it immediately.
>
> **Step 1 - Find the fake Summary-LSA.** Apply:
> ```
> ip.src == 10.20.30.77 and ospf.msg == 4
> ```
> Click the second result (t ≈ 57 s) - the one carrying the Summary-LSA, not the MaxAge LSA.
>
> **Step 2 - Read the sequence number.** Expand **Open Shortest Path First -> LS Update Packet**. Expand the LSA. Confirm `LS Type: Summary-LSA (IP network) (3)` and `Link State ID: 10.99.88.0`. Read the `Sequence Number` field. Wireshark displays it in hexadecimal.

`0x80000005`

---
