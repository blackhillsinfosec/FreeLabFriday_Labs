# OSPF Packet Analysis

**Capture file:** `ospf_lab.pcap`

---

## Topology

| Role | Router-ID | IP Address | MAC Address |
|---|---|---|---|
| Designated Router (DR) | 192.168.100.1 | 192.168.100.1/24 | 00:00:00:aa:00:01 |
| Backup DR (BDR) | 192.168.100.2 | 192.168.100.2/24 | 00:00:00:aa:00:02 |
| Internal Router | 192.168.100.3 | 192.168.100.3/24 | 00:00:00:aa:00:03 |
| **Attacker** | 192.168.100.99 | 192.168.100.99 | de:ad:be:ef:00:99 |

All four nodes share a single broadcast Ethernet segment (Area 0.0.0.0).

---

## Part 1 - OSPF on the Wire

### Background

OSPF (Open Shortest Path First) is an IGP that runs directly over IP using protocol number **89** - there is no TCP or UDP header. Each OSPF packet begins with a 24-byte header: Version (always 2 for OSPFv2), Type (1–5), Packet Length, Router ID (the 4-byte identifier of the originating router, encoded as a dotted-quad), Area ID, Checksum, Auth Type, and 8 bytes of Auth Data

On a broadcast multi-access segment such as Ethernet, most OSPF packets are sent to one of two multicast addresses:

- **224.0.0.5** (`AllSPFRouters`, MAC `01:00:5e:00:00:05`) - every OSPF router listens here
- **224.0.0.6** (`AllDRouters`, MAC `01:00:5e:00:00:06`) - only the DR and BDR listen here; other routers send LSUs and LSAcks to this address so the DR can re-flood to 224.0.0.5

The five packet types are **Hello** (1), **Database Description/DBD** (2), **LS Request/LSR** (3), **LS Update/LSU** (4), and **LS Acknowledge/LSAck** (5)

### Steps

1. Open `ospf_lab.pcap` in Wireshark. Observe the mixed traffic including **ARP**, **DNS**, **NTP**, **ICMP**, **syslog**, and **TLS**

2. Apply the display filter:

```
ip.proto == 89
```

The packet list drops to **60 rows** - all OSPF. Notice the `Info` column shows Hello, DB Description, LS Request, LS Update, and LS Acknowledge entries

3. Double Click the first Hello packet (t ≈ 1 s, src 192.168.100.1). Expand **Open Shortest Path First** and then **OSPF Header**. Observe:
   - `Version: 2`
   - `Message Type: Hello Packet (1)`
   - `Packet Length: 44` - total OSPF packet size in bytes
   - `Source OSPF Router: 192.168.100.1`
   - `Area ID: 0.0.0.0`
   - `Auth Type: Null (0)`

4. In the bottom panel (hex dump), identify the first byte after the IP header. For a standard IPv4 packet with no options the IP header is 20 bytes and the Ethernet header is 14 bytes, so the OSPF header starts at byte offset **34**. Confirm `0x02` (version 2) is there and `0x01` (type Hello) is at byte 35

5. Look at the Destination IP in the IP header: `224.0.0.5`. Switch to the Ethernet header and confirm the destination MAC is `01:00:5e:00:00:05`

6. Clear the filter. Apply:

```
ip.proto == 89 and ip.dst == 224.0.0.6
```

You will see packets sent to AllDRouters - these are the LSU and LSAck packets exchanged between the DR/BDR and the other routers

---

## Part 2 - Neighbour Formation Sequence

### Background

OSPF neighbour formation on a broadcast segment follows a well-defined Finite State Machine (FSM). The key states visible in this capture are:

- **Init** - a router has received a Hello from a neighbour but does not see itself listed in that Hello's neighbour list
- **2-Way** - both routers see each other in each other's Hello. The DR and BDR are elected once all routers have reached 2-Way
- **ExStart** - the DR and each non-DR router negotiate a Master/Slave relationship and an initial DD Sequence Number using DBD packets with the I (Init), M (More), and MS (Master) flags set
- **Exchange** - DBD packets carrying LSA headers describe the contents of each router's LSDB
- **Loading** - missing LSAs are requested with LSR and fulfilled with LSU
- **Full** - LSDBs are synchronised; the adjacency is complete

### Steps

1. Filter:

```
ip.proto == 89
```

2. Locate the three Hello packets at t ≈ 1 s (one from each of 192.168.100.1, .2, .3). Click the Hello from 192.168.100.1. Expand **Open Shortest Path First -> Hello Packet**. Observe:

- `Designated Router: 0.0.0.0` - no DR elected yet
- `Backup Designated Router: 0.0.0.0`
- `Active Neighbor` list is non-existent, it being the first "Hello"

This is the **Init** state

3. Locate the Hello packets at t ≈ 2 s. Click the one from 192.168.100.1. Expand **Hello Packet**:

- `Designated Router: 192.168.100.1` - R1 has been elected DR
- `Backup Designated Router: 192.168.100.2` - R2 is BDR
- `Active Neighbor` entries now list 192.168.100.2 and 192.168.100.3

This transition to **2-Way** is visible because routers now see themselves in peers' neighbour lists

4. Filter for DBD packets:

```
ospf.msg == 2
```

**12 packets** appear. Click the first one (t = 3.9 s, src 192.168.100.1, dst 192.168.100.2). Expand **Open Shortest Path First -> DB Description**:

- `DB Description Flags: 0x07` - bits I=1, M=1, MS=1 (Init, More, Master)
- `DD Sequence Number` - R1's initial DD sequence number

This is the **ExStart** state

5. Click the next DBD from 192.168.100.2 (a moment later). It also has flags `0x07` - R2 also claims Master. The router with the higher Router-ID wins; since 192.168.100.1 > 192.168.100.2, R1 becomes Master

6. Click the DBD at t = 4.15 s from 192.168.100.1 with flags `0x03` (M+MS, no Init). Expand the LSA Headers listed inside it - these are the headers of LSAs R1 is summarising from its LSDB. This is the **Exchange** state

7. Filter for LSR:

```
ospf.msg == 3
```

**2 packets** - R2 and R3 each request LSAs they do not have. Click R2's LSR (src 192.168.100.2). Expand **LS Request**; note each request has `LS Type`, `Link State ID`, and `Advertising Router`. This is the **Loading** state

8. The LSAck packets following the LSU exchange (visible with `ospf.msg == 5`) confirm **Full** state has been reached

---

## Part 3 - LSA Flooding and Sequence Numbers

### Background

When OSPF needs to propagate topology changes, the originating router sends a Link State Update (LSU) packet containing one or more LSAs. Each LSA has a 20-byte header: LS Age (time in seconds since origination), Options, LS Type, Link State ID (the address being advertised), Advertising Router, LS Sequence Number (monotonically increasing, starts at 0x80000001), LS Checksum (Fletcher-16 over the LSA excluding the Age field), and Length.

On a broadcast network, the DR re-floods LSUs received from non-DR routers out to 224.0.0.5 so all routers receive them. Receiving routers must acknowledge with an LSAck. If no LSAck is received within the retransmission interval (default 5 s), the sender re-floods.

LS Sequence Numbers increase with each new origination. LSAs with age 3600 (MaxAge) are immediately flushed - they signal that a prefix should be removed from all LSDBs.

### Steps

1. Filter:

```
ospf.msg == 4
```

**8 LSU packets** appear. Click the LSU at t = 5.1 s from 192.168.100.1 (sent to 224.0.0.6). Expand **Open Shortest Path First -> LS Update Packet**:

- `Number of LSAs: 2`

- Expand the first LSA (**Router-LSA**):
    - `LS Age: 1`
    - `LS Type: Router-LSA (1)`
    - `Link State ID: 192.168.100.1` - same as Advertising Router for Router-LSAs
    - `Advertising Router: 192.168.100.1`
    - `Sequence Number: 0x80000001`
    - `LS Checksum` - the Fletcher-16 value

- Expand the second LSA (**Network-LSA**):
    - `LS Type: Network-LSA (2)`
    - `Link State ID: 192.168.100.1` - the DR's interface IP on this segment
    - Expand **Attached Router** entries - you should see 192.168.100.1, .2, and .3 listed

2. Click the routine refresh LSU at t = 29.9 s from 192.168.100.1. Observe the Router-LSA now has:

- `Sequence Number: 0x80000002` - incremented from the initial 0x80000001

- `LS Age: 1` - freshly originated

3. Filter:

```
ospf.msg == 5
```

**11 LSAck packets** appear. Click the first LSAck from 192.168.100.2 at t = 5.3 s. Expand **Open Shortest Path First -> LSA-type 1 and 2** - you see 20-byte LSA headers listing the LSAs being acknowledged, identified by Type + Link State ID + Advertising Router + Sequence Number.

4. To see all LSAs of a specific type, clear the filter and apply:

```
ospf.lsa == 1
```

This shows all frames containing a Router-LSA.

5. To isolate the Network-LSA:

```
ospf.lsa == 2
```

---

## Part 4 - OSPF Attack Techniques

### Background

OSPF attacks exploit the lack of authentication that is common in real deployments, or weaknesses in the protocol itself. The three attacks visible in this capture are:

**MaxAge LSA Poisoning:** An attacker injects an LSA with LS Age = 3600 (the MaxAge constant) for a legitimate router's prefix. All routers that receive this LSA immediately remove the corresponding route from their LSDB, effectively blackholing traffic to that prefix until the legitimate router re-originates with a higher sequence number.

**Fake Hello with Mismatched Parameters:** An attacker sends a Hello claiming to be a new router but with a Dead Interval (80 s) that does not match the segment's configured value (40 s). Routers receiving a Hello with a mismatched Dead Interval will ignore it and may log a warning, and if the Hello appears to come from an existing neighbour it can cause that adjacency to reset.

**Spoofed LSU with False Route:** An attacker sends an LSU with the Advertising Router field in the LSA header set to a legitimate router's Router-ID (here, R1 = 192.168.100.1), injecting a summary prefix (10.0.99.0/24) that does not exist. Routers install the false route in their LSDB until the sequence number is superseded.

### Steps

1. Filter:

```
ip.src == 192.168.100.99 and ip.proto == 89
```

**3 attack packets** appear at t = 50, 51, and 52 s.

2. **Attack #1 - Bad Hello.** Click the packet at t ≈ 50 s. Expand **Open Shortest Path First -> Hello Packet**:
   
- `Source OSPF Router: 192.168.100.99` - the attacker's Router-ID
- `Router Dead Interval: 80` - legitimate routers use 40; this mismatch will cause the Hello to be rejected
- `Active Neighbor` list contains `192.168.100.3` - claiming to be a neighbour of R3 to disrupt that adjacency
- `Designated Router: 0.0.0.0` - the attacker claims no DR, further signalling an inconsistent view

3. **Attack #2 - MaxAge LSA.** Click the LSU packet at t ≈ 51 s (src 192.168.100.99). Expand **LS Update Packet -> LSA-type 1**:

- `LS Age: 3600` - this is the MaxAge value; any receiving router will immediately flush this LSA
- `LS Type: Router-LSA (1)`
- `Link State ID: 192.168.100.3` - the attacker is flushing R3's Router-LSA
- `Advertising Router: 192.168.100.3` - spoofed to look like R3 originated it
- `Sequence Number: 0x80000001` - matches R3's current sequence number; routers accept this as a valid newer age for the same instance

4. **Attack #3 - Fake Summary-LSA.** Click the LSU at t ≈ 52 s. Expand **LS Update Packet -> LSA-type 3**:

- `LS Type: Summary-LSA (IP network) (3)`
- `Link State ID: 10.0.99.0` - the false prefix
- `Advertising Router: 192.168.100.1` - spoofed as R1 (the DR)
- `Sequence Number: 0x80000001`
- **Network Mask: 255.255.255.0**, **Metric: 10**

Routers receiving this will add 10.0.99.0/24 -> R1 to their routing tables

5. Observe the legitimate response. Filter:
   
```
ip.src == 192.168.100.1 and ospf.msg == 4 and frame.time_relative >= 54
```

The LSU at t ≈ 55 s shows R1 re-flooding with `Sequence Number: 0x80000002`, superseding the attacker's entry. R3's re-originated LSU at t ≈ 56 s similarly uses 0x80000002

---

## Part 5 - Authentication Fields

### Background

OSPFv2 supports three authentication modes, identified by the 16-bit Auth Type field at bytes 14–15 of every OSPF header:

- **Type 0 - Null:** No authentication. The 8-byte Auth Data field is all zeros. This is the default and enables all the attacks in Part 4
- **Type 1 - Simple Password:** A plaintext password (up to 8 bytes) is placed directly in the Auth Data field. Wireshark displays it as a string
- **Type 2 - Cryptographic (MD5):** The Auth Data field carries a Key ID, Auth Data Length, and a Cryptographic Sequence Number. A 16-byte MD5 hash of the OSPF packet is appended after the packet (not included in the OSPF Length field). The OSPF checksum field is set to zero for MD5-authenticated packets

### Steps

1. Find a null-auth packet (the vast majority of this capture). Click any Hello at t < 20 s. Expand **Open Shortest Path First**:

- `Auth Type: Null (0)`
- `Auth Data (none)` - eight zero bytes

2. Filter for the simple-password Hello:

```
ospf.auth.type == 1
```

**1 packet** - the Hello from 192.168.100.1 at t ≈ 20 s. Expand **Open Shortest Path First**:

- `Auth Type: Simple Password (1)`
- `Auth Data (Simple): ospf1234` - the password in plaintext. Anyone capturing traffic can read this directly

3. Filter for the MD5 Hello:

```
ospf.auth.type == 2
```

**1 packet** - the Hello from 192.168.100.2 at t ≈ 21 s. Expand **Open Shortest Path First**:

- `Auth Type: Cryptographic (2)`
- Key ID, Auth Data Length (16), Cryptographic Sequence Number
- `Checksum: 0x0000` - zeroed per RFC 2328 for MD5 packets
- Note the 16 bytes appended after the OSPF packet body (shown in hex at the bottom)

4. Confirm the relationship between absent auth and the attacks: every attack packet (filter `ip.src == 192.168.100.99`) uses `Auth Type: Null (0)`. A deployment enforcing MD5 authentication would discard all three packets because the attacker cannot forge a valid hash without knowing the shared key

---

## Part 6 - Detection Indicators

### Background

A passive observer on the same broadcast segment (or with a span/tap) can identify OSPF attacks by watching for several anomalies. This Part maps each indicator to concrete evidence in the capture

**Duplicate / unexpected Router-IDs:** A Router-ID not previously seen in any Hello or LSA, suddenly appearing in an LSU or Hello, is a strong indicator of injection. Legitimate routers announce themselves via Hello before originating LSAs

**LSA arriving from a non-DR source:** On a broadcast segment, LSUs (other than those sent between adjacent neighbours in unicast during Exchange/Loading) should originate from the DR or BDR. An LSU arriving from a router that is neither DR nor BDR and that is sent to AllDRouters (224.0.0.6) is suspicious

**MaxAge LSAs for stable routes:** An LS Age of 3600 on an LSA whose last legitimate age was 1 is a sudden and unexplained flush - a strong attack signal, especially if the Advertising Router differs from the source IP

**Hello interval / dead interval mismatches:** OSPF routers must agree on Hello and Dead intervals; mismatches cause Hellos to be ignored. An Hello with a non-standard Dead Interval from an unknown source is a probe or attack setup

**Unexpected LSU floods:** A burst of LSUs from a source that is not the DR/BDR or a known adjacency is anomalous. Legitimate traffic at steady state is periodic and sparse

### Steps

1. **Indicator 1 - New Router-ID.** Apply:

```
ip.src == 192.168.100.99 and ip.proto == 89
```

**3 packets** - all from the attacker, first appearing at t = 50 s. Browse through the 27 Hello packets earlier in the capture (filter `ospf.msg == 1`): 192.168.100.99 never appears as `Source OSPF Router` in any Hello before t = 50 s. A monitoring tool watching the Hello neighbour list would see no prior record of this Router-ID

2. **Indicator 2 - MaxAge on a stable LSA.** Apply:

```
ospf.lsa.age == 3600
```

**1 packet** - the MaxAge injection at t = 51 s. In contrast, all legitimate LSAs in the capture have LS Age 1 (freshly originated). A value of 3600 in isolation is always suspicious

3. **Indicator 3 - Source IP ≠ Advertising Router.** Click the MaxAge LSU (t ≈ 51 s). The source IP (shown in the IP header) is `192.168.100.99` but the LSA's Advertising Router field is `192.168.100.3`. Legitimate OSPF operation requires the IP source address of an LSU to match the Router-ID of the Advertising Router for self-originated LSAs. This discrepancy is unambiguous evidence of spoofing

4. **Indicator 4 - Dead Interval mismatch.** Apply:

```
ospf.hello.router_dead_interval != 40 and ospf.msg == 1
```

**1 packet** - the attacker's Hello (t ≈ 50 s). All legitimate Hello packets in this capture use Dead Interval 40

5. **Indicator 5 - Unexpected LSU burst.** Apply:

```
ip.src == 192.168.100.99 and ospf.msg == 4
```

Two LSUs from 192.168.100.99 in rapid succession (t = 51, 52 s) - a router that has never completed an adjacency (never reached Full state) has no business originating LSAs


---

## Quick Reference Filter Table

| Goal | Wireshark Display Filter |
|---|---|
| All OSPF traffic | `ip.proto == 89` |
| OSPF only (protocol name) | `ospf` |
| Hello packets | `ospf.msg == 1` |
| Database Description packets | `ospf.msg == 2` |
| LS Request packets | `ospf.msg == 3` |
| LS Update packets | `ospf.msg == 4` |
| LS Acknowledge packets | `ospf.msg == 5` |
| Packets to AllSPFRouters | `ip.dst == 224.0.0.5` |
| Packets to AllDRouters | `ip.dst == 224.0.0.6` |
| From attacker | `ip.src == 192.168.100.99` |
| Null auth | `ospf.auth.type == 0` |
| Simple password auth | `ospf.auth.type == 1` |
| MD5 auth | `ospf.auth.type == 2` |
| MaxAge LSAs | `ospf.lsa.age == 3600` |
| Router-LSAs | `ospf.lsa == 1` |
| Network-LSAs | `ospf.lsa == 2` |
| Summary-LSAs | `ospf.lsa == 3` |
| Dead interval ≠ 40 | `ospf.hello.dead_interval != 40` |
| Non-OSPF only | `not (ip.proto == 89)` |
| Only ICMP | `icmp` |
| Only DNS | `udp.port == 53` |
| Only TLS | `tcp.port == 443` |

---

### OSPF Neighbour FSM

```
  +---------+
  |  Down   |  (no Hello received)
  +---------+
       |
       | Receive Hello (not seeing self in neighbour list)
       v
  +---------+
  |  Init   |
  +---------+
       |
       | Receive Hello WITH self in neighbour list (2-Way event)
       v
  +---------+
  |  2-Way  |  <-- DR/BDR election occurs here on broadcast segments
  +---------+
       |
       | AdjOK decision (is this router DR or BDR, or is peer DR/BDR?)
       v
  +-----------+
  | ExStart   |  DBD I+M+MS - negotiate Master/Slave & initial DD seq
  +-----------+
       |
       | Master/Slave agreed
       v
  +-----------+
  | Exchange  |  DBD packets carry LSA headers; LSDB summaries exchanged
  +-----------+
       |
       | Done sending DBD summaries
       v
  +-----------+
  |  Loading  |  LSR -> LSU -> LSAck; missing LSAs fetched
  +-----------+
       |
       | No outstanding LSRs remain
       v
  +---------+
  |  Full   |  LSDBs synchronised; adjacency complete
  +---------+
```
