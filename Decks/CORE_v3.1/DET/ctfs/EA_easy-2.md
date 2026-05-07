![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Event Log Review

You are reviewing Windows Security Event logs on a server after an after-hours alert. You notice the following sequence of events:

```
[2024-11-14 02:13:41]  EventID: 4625  Account: administrator  Logon Type: 3  Result: FAILURE
[2024-11-14 02:13:42]  EventID: 4625  Account: administrator  Logon Type: 3  Result: FAILURE
[2024-11-14 02:13:43]  EventID: 4625  Account: administrator  Logon Type: 3  Result: FAILURE
[2024-11-14 02:13:44]  EventID: 4625  Account: administrator  Logon Type: 3  Result: FAILURE
[2024-11-14 02:13:45]  EventID: 4624  Account: administrator  Logon Type: 3  Result: SUCCESS
[2024-11-14 02:14:02]  EventID: 4720  Account: backdoor_user  Performed by: administrator
```

---

## Question

What does this sequence of events most likely indicate?

---

## Flags (Choose One)

- **A)** A brute-force attack succeeded and the attacker immediately created a new backdoor account
- **B)** An admin forgot their password, reset it, then created a new team member account
- **C)** The server's audit policy is misconfigured and generating false positives
- **D)** A vulnerability scanner triggered automated login attempts during a scheduled scan

---

Correct Flag: **A**

---

# Finished?
[Next Question](EA_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/EA/Endpoint_Analysis.md)
