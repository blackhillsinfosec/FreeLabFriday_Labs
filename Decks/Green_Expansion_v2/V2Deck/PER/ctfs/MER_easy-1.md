![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Spot the Rule

A user calls the help desk saying they never received a password reset email they requested. You log into the admin panel and pull up their mailbox rules.

You find this rule configured on their account:

```
Rule Name: (no name)
Condition: Subject contains "password" OR "reset" OR "verify"
Action: Delete permanently
Run on: All incoming mail
Created: 2024-11-03 02:14 AM
```

The user says they have never set up any inbox rules.

---

## Question

What is the most likely explanation for this rule?

---

## Flags (Choose One)

- **A)** The mail server automatically created the rule to prevent spam
- **B)** The user set it up and forgot about it
- **C)** An attacker created the rule to block security notifications from reaching the user
- **D)** The rule was pushed by the IT department as a group policy

---

Correct Flag: **C**

---

# Finished?

[Next Question](MER_easy-2.md)  
[Back to Card's Main Page](../Malicious_Email_Rules.md)
