# WireGuard CTF - Questions & Answers

**Capture file:** wireguard_ctf.pcap

---

**Q1. What is the IP address of the WireGuard responder?**
> Filter: wg.type == 1 -> click the first Handshake Initiation -> look at the Destination column.

`203.0.113.99`

---

**Q2. What is the Sender Index (hex) in the first Handshake Initiation?**
> Filter: wg.type == 1 -> click the first packet -> expand WireGuard in the detail pane -> read the Sender Index field. This is a little-endian u32 the initiator randomly picks to demux replies.

`0x1337c0de`

---

**Q3. How many complete WireGuard sessions were established in the capture?**
> Filter: wg.type == 1 -- each result is one Handshake Initiation, and each Init corresponds to exactly one session. The capture includes the initial session plus one rekey, which triggers a full new handshake.

`2`

---

**Q4. What UDP length value (decimal) identifies a WireGuard keepalive, and what is the breakdown?**
> Filter: wg.type == 4 && udp.length == 40 -- keepalives appear. Work backwards: 8 (UDP header) + 16 (WireGuard transport header) + 0 (empty plaintext) + 16 (Poly1305 tag) = 40.

`40`  (8 UDP + 16 WG header + 16 Poly1305 tag, zero payload bytes)

---

**Q5. What receiver_index (hex) do the initiator transport packets carry in Session 2?**
> Filter: wg.type == 4 && ip.src == 10.13.37.5 && frame.time_relative > 180 -> expand WireGuard on any result -> read the Receiver Index field. This equals the Sender Index the responder chose in the Session 2 Handshake Response.

`0xfaceb00c`

---

**Q6. How many non-WireGuard packets are in the capture?**
> Filter: !wg -> count the results. Noise: ARP (2), DNS query/response pairs (10), TCP handshakes and data (18).

`30`

---

**Q7. What source port does the initiator use for all WireGuard traffic?**
> Filter: `wg.type == 1` -> click the first Initiation -> look at the **Source Port** in the UDP header. Unlike the responder's well-known port 51820, the initiator uses an ephemeral port that stays fixed for the entire capture - both sessions use the same one.

`54321`

---

**Q8. What is the Receiver Index in the Session 1 Handshake Response, and why does it match something you have already seen?**
> Filter: `wg.type == 2` -> click the first Response -> expand **WireGuard** -> read the **Receiver Index** field. It echoes the Sender Index from the Session 1 Initiation - this is how the initiator verifies the response is for its own session and not a stale or spoofed reply.

`0x1337c0de`  (equals the Session 1 Init Sender Index from Q2)

---

**Q9. What DNS server appears in the background noise traffic, and what domains were queried?**
> Filter: `udp.port == 53` -> look at the Destination column for query packets (src port != 53). Expand the DNS layer to read the queried names. Five unique queries are present across the capture.

`8.8.8.8` - domains: `example.com`, `github.com`, `api.stripe.com`, `update.example.org`, `metrics.internal`

---

**Q10. What is the highest counter value seen on initiator transport packets in Session 1, and what type of packet carries it?**
> Filter: `wg.type == 4 && ip.src == 10.13.37.5 && wg.receiver == 0xdeadbeef` -> sort by time -> click the last packet -> expand **WireGuard** -> read **Counter**. Cross-check `udp.length` to determine whether it is a keepalive or data packet.

`32` - carried by a **keepalive** (`udp.length == 40`), the second PersistentKeepalive fired at ~t=50s after the second ping batch completed.

---
