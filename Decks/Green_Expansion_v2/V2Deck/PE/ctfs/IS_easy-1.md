![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Suspicious Sender

A user reports receiving a strange email. You pull it up and see the following:

```
From: john.martinez@company.internal
To: sarah.chen@company.internal
Subject: Re: Q3 Budget Review - updated file

Hi Sarah,

I updated the spreadsheet we were discussing. Let me know if the numbers look right.

[Download: Q3_Budget_Final.xlsm]
```

You check the email logs and notice that john.martinez has not logged into his workstation in 3 days - he is on vacation. His account, however, shows login activity from an IP in Eastern Europe 6 hours ago.

---

## Question

What most likely describes what is happening here?

---

## Flags (Choose One)

- **A)** John sent the email before going on vacation and it was delayed
- **B)** Sarah triggered an automated budget report
- **C)** The email client is malfunctioning and showing wrong sender metadata
- **D)** An attacker is using John's compromised account to deliver a malicious file to a trusted colleague

---

Correct Flag: **D**

---

# Finished?
[Next Question](IS_easy-2.md)
[Back to Card's Main Page](../Internal_Spearphishing.md)
