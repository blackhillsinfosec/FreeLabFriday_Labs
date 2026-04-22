# Lab: LDAP Traffic Analysis Solution

**PCAP File:** `dns.pcap` // [click me for pcap file](./dns.pcap)

---

## Lab Instructions

This guide walks you through analyzing LDAP traffic step by step. You’ll use Wireshark (GUI) or tcpdump (CLI), apply filters, inspect packet details, and answer key questions.

---

### 1. Load the PCAP

**Objective:** Open the capture file to begin analysis.

**Wireshark (GUI):**

1. Launch Wireshark.
2. Click **File → Open**.
3. Select **dns.pcap** and click **Open**.
4. Observe the full packet list.

<img width="530" height="226" alt="image" src="https://github.com/user-attachments/assets/bb8aeac6-d146-4003-a45c-afb209230f93" />


**tcpdump (CLI):**

```bash
$ tcpdump -r dns.pcap tcp port 389
```

- **-r dns.pcap**: Read from the file.
- **tcp port 389**: Only display LDAP traffic.

>[!TIP]
> 
> tcpdump shows raw bytes; prefer Wireshark for LDAP protocol decoding.

---

### 2. Identify LDAP Traffic

**Objective:** Filter out irrelevant packets.

**Wireshark display filter:**

```
ldap or tcp.port == 389
```
<img width="1849" height="431" alt="image" src="https://github.com/user-attachments/assets/450b2e57-cc5b-4442-88d3-6dc01779d97e" />

- **ldap**: Decoded LDAP messages.
- **tcp.port == 389**: Any TCP packet on port 389.

**tcpdump filter:**

```bash
$ tcpdump -r dns.pcap tcp port 389
```

<img width="1843" height="505" alt="image" src="https://github.com/user-attachments/assets/f45569fb-98b6-4b98-bfa6-19530fc1e03a" />


---

### 3. Count Packets

**Objective:** Determine total LDAP messages exchanged (requests + responses).

1. Apply the filter `ldap`, check Wireshark’s status bar for **Displayed: 14 (7.7%)**.
2. **Answer:** 14 LDAP messages.

>[!TIP]
>
> _Why it matters:_ Knowing volume helps assess session complexity.

<img width="1854" height="1053" alt="image" src="https://github.com/user-attachments/assets/aec94da1-3d64-44f2-8fb4-a54c3c30fed6" />


---

### 4. Analyze LDAP Simple Binds

**Objective:** Examine the authentication bind operation.

#### 4.1 Locate bindRequest

- **Filter:**
  ```
  ldap.messageID == 3 && ldap.bindRequest_element
  ```
- **Result:** Two packets 
<img width="1156" height="154" alt="image" src="https://github.com/user-attachments/assets/4d722a1e-f43f-469d-a178-233dc2f7c417" />


#### 4.2 Extract bindRequest details

| **Field**          | **Value**            | **Description**                                   |
| ------------------ | -------------------- | ------------------------------------------------- |
| Client IP:Port     | 192.168.122.190:51635 | Source endpoint initiating bind                   |
| Server IP:Port     | 192.168.122.189:389  | LDAP server endpoint                              |
| LDAP Version       | 3                    | Protocol version                                 |
| Bind DN            | `<MISSING>`          | Absent for SASL; simple binds would list DN      |
| Auth Type          | SASL (3)             | SASL indicates advanced mechanism; simple=0       |
| SASL Mechanism     | GSS-SPNEGO         | Kerberos-based secure authentication negotiation       |


In **LDAP**, the **Bind DN (Distinguished Name)** identifies the client attempting to authenticate.

- For **Simple Binds**, the client typically provides a plain-text DN (e.g., `cn=admin,dc=example,dc=com`) along with a password.
  
- For **SASL Binds**, the authentication mechanism is more complex (e.g., **Kerberos**, **DIGEST-MD5**, etc.) and may not require the DN to be explicitly provided in the Bind Request.

In this case, the **Bind DN is absent** because the client used **SASL authentication**, which negotiates credentials differently and often does **not include a DN** in the initial request. This is **expected behavior** for SASL binds.

<img width="915" height="304" alt="image" src="https://github.com/user-attachments/assets/b53bc5c5-d8e0-4660-b035-3fac72534dae" />


#### 4.3 Inspect bindResponse

- **Filter:**
  ```
  ldap.messageID == 3 && ldap.bindResponse_element
  ```
- **Result:** Two packets labeled **Bind Response**:

| **Field**       | **Value**              | **Explanation**                                 |
| --------------- | ---------------------- | ----------------------------------------------- |
| Result Code     | saslBindInProgress(14) | SASL exchange ongoing; not final success/fail   |

**Answer to Question 2**

> **What DN did the client bind as, and was authentication successful?(may be a tricky question)**
>
> - **Bind DN:** _Not present_ (SASL bind hides DN)
> - **Authentication:** In progress (saslBindInProgress **14**). Look for a later bindResponse code **0** (success) or **49** (invalidCredentials) to conclude. //Check package no. 159

<img width="922" height="340" alt="image" src="https://github.com/user-attachments/assets/49140f4a-12a0-43d0-9f87-34d89346f70c" />


---

### 5. Analyze LDAP Search Operations

**Objective:** Examine directory search requests and results.

#### 5.1 Locate searchRequest packets

- **Filter alternatives:**
  ```
  ldap.searchRequest_element
  ```
  or by ID:
  ```
  ldap.messageID == 1 && ldap.searchRequest_element
  ldap.messageID == 2 && ldap.searchRequest_element
  ```


<img width="1856" height="198" alt="image" src="https://github.com/user-attachments/assets/76e9aca8-d9ac-4f82-8f82-0faffeaf3d1a" />


#### 5.2 searchRequest details(here are the searchRequest details for messageID == 1 only)

| **Field**       | **Value**           | **Description**                                        |
| --------------- | ------------------- | ------------------------------------------------------ |
| Message ID      | 1             | Correlates request ↔ response                          |
| Base DN         | `<MISSING>`         | Empty means root DSE (directory service entry)         |
| Scope           | baseObject (0)      | Only the base entry, no children (shallow search)      |
| Filter          | (objectClass=*)     | Matches all objects under Base DN                      |

<img width="534" height="286" alt="image" src="https://github.com/user-attachments/assets/934f8dbf-4ce3-4c60-a9e7-df1680ffa107" />

#### 5.3 Count search results

- **Filter responses:**
  ```
  ldap.messageID == 1 && ldap.searchResEntry_element
  ldap.messageID == 1 && ldap.searchResDone_element
  ldap.messageID == 2 && ldap.searchResEntry_element
  ldap.messageID == 2 && ldap.searchResDone_element
  ```
- **Entries returned:**
  - ID 1: 2 entries
  - ID 2: 2 entries
- **Result code (searchResDone):** success (0)

<img width="865" height="401" alt="image" src="https://github.com/user-attachments/assets/ccbd5e19-1561-4fdd-8069-c25a68ed32be" />


**Answer to Questions 3 & 4**

> **What Base DN was used, and how many entries returned?**
>
> - **Base DN:** Root DSE (empty / _<MISSING>_)
> - **Entries:** 2 per search (IDs 1 & 2)
>
> **What scope was used in search requests?**
>
> - **Scope:** baseObject (0) — only the specified entry.

---

### 6. Analyze LDAP Unbind

**Objective:** Confirm session closure.

#### 6.1 Locate unbindRequest

- **Filter:**
  ```
  ldap.unbindRequest_element
  ```
- **Result:** Two packets (messageID 4).

<img width="1329" height="101" alt="image" src="https://github.com/user-attachments/assets/2b790ed4-4cdb-44b3-8833-b0f100b40072" />


#### 6.2 Verify TCP teardown

1. Right-click → **Follow → TCP Stream**.

<img width="1302" height="527" alt="image" src="https://github.com/user-attachments/assets/9b9d51e7-c927-45b5-a926-a30f3687f543" />


2. After unbindRequest observe:
   - Client → Server: **FIN, ACK**
   - Server → Client: **FIN, ACK**
   - Client → Server: **ACK**

**Answer to Question 5**

> **List the TCP flags observed during session establishment and teardown:**
>
> - **Establishment (3‑way handshake):**
>   1. SYN
>   2. SYN, ACK
>   3. ACK
>
> - **Teardown:**
>   1. FIN, ACK (client)
>   2. FIN, ACK (server)
>   3. ACK (client)


<img width="1135" height="105" alt="image" src="https://github.com/user-attachments/assets/735b390c-359f-4075-a8c6-5b08fe8fb27c" />

---

### 7. Answer Questions


#### Q1: How many LDAP operations (requests) did the client perform?
- **Count method:** 
  ```
  ldap
  ```
  count individual operations by messageID (IDs 1, 2, 3, 4).
- **Result:**
  - **Bind Request:** 2x2 (ID 3)
  - **Search Requests:** 4x2 (IDs 1 & 2)
  - **Unbind Request:** 1x2 (ID 4)
  - **Total Requests:** **7x2** 



---

#### Q2: What DN did the client bind as, and was authentication successful?
- **Bind DN:** *Not present* in the packet because it’s a SASL bind. Simple binds would display a DN such as `cn=admin,dc=example,dc=com` here.
- **Authentication Status:**
  - **Result Code:** saslBindInProgress (14)
  - **Interpretation:** SASL handshake is ongoing; no final success/failure in this capture.
  - **To confirm success/failure:** look for a later **bindResponse** with code **0** (success) or **49** (invalidCredentials). //in our case code **0** (success)

>[!TIP]
>
> *Educational tip:* SASL binds are multi-step—Wireshark may show subsequent packets labeled **LDAP: primary message** with EXTERNAL/GSSAPI tokens.

---

#### Q3: What Base DN was used for search, and how many entries returned per operation?
- **Base DN:** Root DSE (empty string, displayed as _<MISSING>_). The root of the directory.
- **Entries Returned:** 2 entries for each of the two searches (IDs 1 & 2).

>[!TIP]
>
> *Why it matters:* Understanding Base DN and result size helps identify scope of directory enumeration.

---

#### Q4: What scope was used in search requests?
- **Scope:** baseObject (0)
- **Meaning:** Only the specified Base DN entry itself is examined, not its children.

>[!TIP]
>
> *Tip:* Other scopes include singleLevel (1) and wholeSubtree (2).

---

#### Q5: List the TCP flags observed during session establishment and teardown.
- **Establishment (3‑way handshake):** SYN → SYN, ACK → ACK
- **Teardown:** FIN, ACK (client) → FIN, ACK (server) → ACK (client)

>[!TIP]
>
> *Insight:* Confirming proper TCP teardown ensures sessions aren’t orphaned, which can be a sign of abnormal termination.

---

#### Q6: Write a Snort/Suricata rule to detect LDAP simple bind attempts.
```snort
alert tcp any any -> any 389 (
  msg:"LDAP Simple Bind Attempt";
  content:"|60|";    # LDAP BindRequest tag (ASN.1 SEQUENCE)
  depth:1;
  content:"|80|";    # simpleAuth [0] tag indicates simple bind
  offset:5;
  classtype:attempted-admin;
  sid:1000001;
  rev:1;
)
```

- **Explanation:**
  - `|60|` is the ASN.1 tag for an LDAP BindRequest.
  - `|80|` at offset 5 matches the simple authentication tag.
  - Adjust `sid` and `classtype` per your policy.

---

## Resources for Studying

- https://cloudshark.org/captures/59ea342b5a13/download
- https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol
- https://www.okta.com/identity-101/what-is-ldap/

---
[Back to the section](/courseFiles/Section_05-networkingAndTelemetry/networkingAndTelemetry.md)
