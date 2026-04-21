# IPSec / IKEv2 CTF - Questions & Answers
**Capture file:** `ipsec-ctf.pcap`

---

**Q1. What UDP port carries the IKE_SA_INIT exchange?**
> Filter: `udp.port == 500` - the first two ISAKMP packets are here.

`500`

---

**Q2. What is the Initiator SPI of the IKE SA?**
> Filter: `isakmp.exchangetype == 34` -> click the initiator packet -> expand ISAKMP header -> look for "Initiator SPI" or `cookie X->0000000000000000` in verbose view.

`3bc4a8800babd2fc`

---

**Q3. What encryption algorithm and key size was negotiated for the IKE SA?**
> Same packet as Q2 -> expand SA payload -> Proposal 1 -> Transform -> `type=encr id=aes, keylen=0100` (0x0100 hex = 256 bits).

`AES_CBC_256`

---

**Q4. What Diffie-Hellman group was used in the IKE_SA_INIT?**
> Same packet as Q2 -> expand KE (Key Exchange) payload -> DH Group field.

`MODP_2048`

---

**Q5. What is the ESP SPI for initiator -> responder traffic in the initial Child SA?**
> Filter: `esp` -> first ESP packet, source `172.16.42.10`, seq=1 -> read the SPI field.

`0xcfe72af7`

---

**Q6. What is the ESP SPI for responder -> initiator traffic in the initial Child SA?**
> Filter: `esp` -> second ESP packet, source `172.16.42.20`, seq=1 -> read the SPI field.

`0xc0e649e3`

---

**Q7. How many ESP packets were sent using the original Child SA SPIs before the first rekey?**
> Filter: `esp` -> count all packets using SPIs from Q5/Q6. They stop at timestamp ~12:39:42 when CREATE_CHILD_SA fires. After the rekey, SPIs change and seq resets to 1.

`32`

---

**Q8. What Message ID did the first CREATE_CHILD_SA request use?**
> Filter: `isakmp.exchangetype == 36` -> first packet -> ISAKMP header -> Message ID field.

`2`

---

**Q9. What is the new initiator -> responder ESP SPI after the first rekey?**
> Filter: `esp` -> find where SPI changes and seq resets to 1 after the rekey -> first new packet from `172.16.42.10` -> read the SPI.

`0xc6df946c`

---

**Q10. How many INFORMATIONAL exchanges were initiated across the entire capture?**
> Filter: `isakmp.exchangetype == 37` -> count only the `[I]` (initiator) packets, or look for `inf2[I]` in the Info column. There are three: at msgid 2 (session start), msgid 3 (after first rekey), and msgid 5 (after IKE rekey).

`3`
