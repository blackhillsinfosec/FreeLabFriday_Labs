#  Lab: LDAP Traffic Analysis (`dns.pcap`)

**PCAP File:** `dns.pcap` (contains LDAP over TCP traffic) // [Click here to download](./dns.pcap)

##  Objective

Analyze the provided PCAP to investigate LDAP operations between a client and server. You will filter LDAP traffic, reconstruct search and bind operations, and interpret LDAP messages—a key skill for SOC investigations involving directory service abuse or enumeration.

---

## Tools & Setup

- **Wireshark** (GUI) or **tcpdump** (CLI)
- PCAP: `dns.pcap` (located in `/home/ubuntu/SOC_Analyst_Labs/wireshark`)

---

## Lab Instructions

- You can either search for **Wireshark** and click on it, or open it from bash:

```bash
wireshark
```

### 1. Load the PCAP

- **Wireshark**: File -> Open -> select `dns.pcap`

<img width="530" height="226" alt="image" src="https://github.com/user-attachments/assets/fe5b2d1a-b049-47e5-9770-73f20cb9fd20" />



- **tcpdump**:
  ```bash
  tcpdump -r dns.pcap tcp port 389
  ```

### 2. Identify LDAP Traffic

- **Wireshark Display Filter**: `ldap` or `tcp.port == 389`

<img width="743" height="294" alt="image" src="https://github.com/user-attachments/assets/eae0f81f-32b3-481e-85a7-de4fe4df8169" />


- **tcpdump Filter**:
  ```bash
  tcpdump -r dns.pcap tcp port 389
  ```

### 3. Count Packets

- How many LDAP messages (requests + responses) are exchanged?

### 4. Analyze LDAP Simple Binds

- Locate the `bindRequest` (operation ID 3)

<img width="1433" height="162" alt="image" src="https://github.com/user-attachments/assets/210b219e-9698-46aa-a484-ac6054d91ea1" />


- Identify:

  - **Client IP & Port**
  - **LDAP version**
  - **Bind DN (Distinguished Name)**
  - **Authentication type** (ex: SASL)

- Locate the matching `bindResponse`

  - **Result code** (ex: `success`, `invalidCredentials`)

### 5. Analyze LDAP Search Operations

- Find each `searchRequest` (operation IDs 1 and 2)

- For each, record:

  - **Base DN** (ex: `<ROOT>`)
  - **Scope** (baseObject, singleLevel, wholeSubtree)
  - **Filter** (ex: `(objectClass=*)` if shown)

- Locate corresponding `searchResEntry` and `searchResDone`

  - **Number of entries returned**
  - **Result code** (could be `success`... or not)

### 6. Analyze LDAP Unbind

- Identify the `unbindRequest`
- Confirm session teardown with subsequent TCP FINs

### 7. Answer Questions

1. How many LDAP operations (requests) did the client perform?
2. What DN did the client bind as, and was authentication successful?(may be a tricky question)
3. What Base DN was used for search, and how many entries returned per operation?
4. What scope was used in search requests?
5. List the TCP flags observed during session establishment and teardown.
6. Write a Snort/Suricata rule to detect LDAP simple bind attempts.

---

## Completion Criteria

- Accurate packet counts for LDAP operations
- Detailed LDAP bind and search metadata
- Understanding of LDAP message structure
- Basic detection rule for LDAP binds

---

## Background

LDAP (Lightweight Directory Access Protocol) on TCP port 389 is used by Active Directory and other directory services. Monitoring LDAP can reveal authentication attempts, directory enumeration, and reconnaissance.

---

When you're done, check out the **step-by-step solution** [here](./wireshark_ldap_lab_solution.md)

---

## Resources for Studying

- https://cloudshark.org/captures/59ea342b5a13/download
- https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol
- https://www.okta.com/identity-101/what-is-ldap/

---
[Back to the section](/courseFiles/Section_05-networkingAndTelemetry/networkingAndTelemetry.md)
