# CovertTCP - IP Identification Covert Channel CTF

---

**Q1. What is the ASCII character encoded in the IP Identification field of the 3rd covert data packet?**

> **Step 1** - Identify the real covert sender's data packets. The red-herring stream
> (172.16.50.99) uses destination port 8080, not 80. Filter to TCP/80 traffic from
> 172.16.50.5 only, and restrict to PSH+ACK (data-carrying) segments:
> ```
> ip.src == 172.16.50.5 and tcp.dstport == 80 and tcp.flags.push == 1
> ```
> This returns **9 rows** - the nine covert data packets.
>
> **Step 2** - Sort by frame number (click the **No.** column header, ascending). The rows
> appear in order 1 through 9 of the covert message.
>
> **Step 3** - In the `ip.id` column (add it via right-click -> Apply as Column on the
> Identification field of any packet if not already visible), read the value for the **3rd
> row**: `0x0050`.
>
> **Step 4** - Convert 0x50 to decimal: 80. Look up decimal 80 in the ASCII table:
> **P** (capital P).

`P`

---

**Q2. What is the full hidden message reconstructed from all covert IPID values?**

> **Step 1** - Apply the data-packet filter from Q1:
> ```
> ip.src == 172.16.50.5 and tcp.dstport == 80 and tcp.flags.push == 1
> ```
> Confirm **9 rows** are returned.
>
> **Step 2** - Sort ascending by frame number. Read the `ip.id` column top to bottom:
>
> | Row | ip.id | Decimal | Char |
> |-----|-------|---------|------|
> | 1 | 0x0054 | 84 | T |
> | 2 | 0x004F | 79 | O |
> | 3 | 0x0050 | 80 | P |
> | 4 | 0x0053 | 83 | S |
> | 5 | 0x0045 | 69 | E |
> | 6 | 0x0043 | 67 | C |
> | 7 | 0x0052 | 82 | R |
> | 8 | 0x0045 | 69 | E |
> | 9 | 0x0054 | 84 | T |
>
> **Step 3** - Concatenate in order: **TOPSECRET**.
>
> **Step 4** - Cross-check: click any data packet, expand **Internet Protocol Version 4**,
> confirm **Identification** matches the value in your table. The TCP payload shows
> `GET / HTTP/1.0\r\n\r\n` - the secret is entirely absent from the payload.

`TOPSECRET`

---

**Q3. What is the destination TCP port used for the real covert session?**

> **Step 1** - Apply:
> ```
> ip.src == 172.16.50.5 and tcp.flags.syn == 1 and tcp.flags.ack == 0
> ```
> One row is returned: the SYN that opens the covert session.
>
> **Step 2** - In the packet-detail pane expand **Transmission Control Protocol**. Read
> the **Destination Port** field.
>
> **Step 3** - Note that the decoy stream (172.16.50.99) uses destination port 8080 - a
> deliberate distractor. The real covert sender uses port **80**.

`80`

---

**Q4. What is the IP Identification value (in hex) of the SYN packet that opens the covert TCP session?**

> **Step 1** - Apply:
> ```
> ip.src == 172.16.50.5 and tcp.flags.syn == 1 and tcp.flags.ack == 0
> ```
> One row is returned.
>
> **Step 2** - Expand **Internet Protocol Version 4** in the detail pane. Read the
> **Identification** field. Wireshark displays it as both hex and decimal:
> `0x1c00 (7168)`.
>
> **Step 3** - Confirm this value is **not** in the printable ASCII range (0x0020–0x007E).
> The handshake packets deliberately use non-ASCII IPIDs to avoid triggering simple
> ASCII-range detectors on session setup traffic.

`0x1c00`

---

**Q5. How many covert data packets carry the hidden message (i.e. what is the message length in characters)?**

> **Step 1** - Apply:
> ```
> ip.src == 172.16.50.5 and tcp.dstport == 80 and tcp.flags.push == 1
> ```
>
> **Step 2** - Read the row count shown in the Wireshark status bar at the bottom of the
> window. It reads **9 displayed**.
>
> **Step 3** - This matches the length of TOPSECRET (9 characters). One packet encodes
> one character; the message length equals the data-packet count.

`9`

---

**Q6. What is the source MAC address of the covert sender?**

> **Step 1** - Apply:
> ```
> ip.src == 172.16.50.5 and tcp.flags.syn == 1 and tcp.flags.ack == 0
> ```
> Click the single returned row - the covert SYN.
>
> **Step 2** - In the packet-detail pane expand **Ethernet II**. Read the
> **Source** field.
>
> **Step 3** - The value is `00:fe:fe:fe:fe:01`. Do not confuse this with the red-herring
> host's MAC (`de:ad:fe:ed:00:99`), which is visually distinctive but belongs to the
> decoy stream, not the real covert sender.

`00:fe:fe:fe:fe:01`

---

**Q7. What is the IP Identification value (in hex) of the first data packet in the decoy stream?**

> **Step 1** - Identify the decoy stream. It originates from 172.16.50.99 (the
> red-herring host, MAC de:ad:fe:ed:00:99) and targets port 8080, not port 80. Apply:
> ```
> ip.src == 172.16.50.99 and tcp.dstport == 8080 and tcp.flags.push == 1
> ```
> This returns **7 rows** - the seven decoy data packets encoding FAKEMSG.
>
> **Step 2** - Sort ascending by frame number. The first row is the first decoy data
> packet.
>
> **Step 3** - Read the `ip.id` column: `0x0046`.
>
> **Step 4** - Convert: 0x46 = 70 decimal = ASCII **F** - the first character of FAKEMSG.
> Chasing this stream to its conclusion yields the wrong answer (FAKEMSG, not TOPSECRET).

`0x0046`

---

**Q8. What TCP flag combination (as a hex byte) appears in the packet that closes the covert session from the sender's side?**

> **Step 1** - Filter to FIN packets from the covert sender:
> ```
> ip.src == 172.16.50.5 and tcp.dstport == 80 and tcp.flags.fin == 1
> ```
> One row is returned.
>
> **Step 2** - Expand **Transmission Control Protocol** in the detail pane. Look at the
> **Flags** line. Wireshark shows:
> ```
> Flags: 0x011 FIN, ACK
> ```
>
> **Step 3** - The raw flags byte has FIN (bit 0) and ACK (bit 4) set:
> 0x01 | 0x10 = **0x11**.

`0x11`

---

**Q9. What is the time delta in seconds between the TCP SYN and the last covert data packet?**

> **Step 1** - Find the SYN frame. Apply:
> ```
> ip.src == 172.16.50.5 and tcp.flags.syn == 1 and tcp.flags.ack == 0
> ```
> Note the **Time** column value for this frame (the absolute timestamp).
>
> **Step 2** - Find the last covert data packet. Apply:
> ```
> ip.src == 172.16.50.5 and tcp.dstport == 80 and tcp.flags.push == 1
> ```
> Sort ascending by frame number. Note the **Time** column value for the **last (9th) row**.
>
> **Step 3** - Subtract: last data packet timestamp minus SYN timestamp.
> SYN is at t = 49000000 s. Last data packet (9th, encoding 'T') is at t = 13.900000 s.
> Delta = 13.900000 − 4.900000 = **9.000000 seconds**.


`9.000000`

---

**Q10. What is the ASCII character encoded in the IP Identification field of the 7th covert data packet?**

> **Step 1** - Apply:
> ```
> ip.src == 172.16.50.5 and tcp.dstport == 80 and tcp.flags.push == 1
> ```
> Confirm **9 rows** returned. Sort ascending by frame number.
>
> **Step 2** - Read the `ip.id` value for the **7th row**: `0x0052`.
>
> **Step 3** - Convert: 0x52 = 82 decimal. ASCII 82 = **R**.
>
> **Step 4** - Cross-check against the full message: T-O-P-S-E-C-**R**-E-T.
> Position 7 is R.

`R`
