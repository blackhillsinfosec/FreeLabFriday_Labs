![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Inbox Takeover

You are investigating a suspected Business Email Compromise (BEC) at a mid-sized company. The CFO's account (`r.chen@acmecorp.com`) was reportedly used to approve a fraudulent wire transfer of $47,000. The CFO denies approving anything.

You are given the following data from three sources:

---

**Cloud Event Log (Microsoft 365 Unified Audit Log):**

```
2024-11-10 01:33 AM - Successful login | IP: 91.108.4.77 (Tor exit node)
2024-11-10 01:34 AM - Set-InboxRule | Condition: From contains "bank", "wire", "transfer",
                      "finance" | Action: Move to "Deleted Items", mark as read
2024-11-10 01:35 AM - Set-InboxRule | Condition: Subject contains "fraud", "unauthorized",
                      "alert" | Action: Delete permanently
2024-11-10 01:38 AM - Accessed Sent Items
2024-11-10 09:02 AM - Successful login | IP: 10.0.0.12 (Corporate network)
2024-11-12 02:14 PM - Email sent to finance@acmecorp.com | Subject: "Updated wire details"
```

**SIEM Correlation Alert (fired on 2024-11-13):**

```
ALERT: Multiple inbox rules created outside business hours
ALERT: Login from anonymization network (Tor) detected
ALERT: Sensitive keyword rules active on executive account
Correlated risk score: 94/100
```

**Mail Server Rule Export (pulled manually on 2024-11-13):**

```
Rule 1 - "cleanup": Move from bank/wire/transfer/finance -> Deleted Items (mark read)
Rule 2 - "(unnamed)": Delete permanently if subject matches fraud/unauthorized/alert
Rule 3 - "legal": Forward ALL outgoing mail to r.chen.backup.2024@protonmail.com
```

---

## Question

The SIEM alert fired three days after the attacker's first login. Which of the following best explains why the fraud was not caught sooner, and what the attacker's rule setup tells you about their level of preparation?

---

## Flags (Choose One)

- **A)** The SIEM was misconfigured and should have caught the Tor login immediately - the rules were basic and the attacker was likely a script kiddie
- **B)** The attacker used a layered rule strategy: blocking bank confirmations, deleting fraud alerts, and forwarding outgoing mail - the three-day gap shows the SIEM lacked real-time correlation on executive accounts
- **C)** The delay happened because cloud log ingestion into the SIEM takes 72 hours by default - the rules were unsophisticated and likely automated
- **D)** The CFO accidentally created the rules while testing a mail filter - the Tor login was a separate unrelated event from a contractor

---

Correct Flag: **B**

---

# Finished?

[Back to Card's Main Page](../Malicious_Email_Rules.md)
