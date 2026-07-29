![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Header Hunt

You are analyzing the raw headers of an internal email flagged by your SIEM. The email claims to be from the IT helpdesk asking users to verify their VPN credentials.

```
Received: from mail.company.internal (10.0.1.5)
Message-ID: <8f2a1b@mail.company.internal>
From: it-helpdesk@company.internal
Reply-To: support-desk@company-it-help.net
X-Originating-IP: 185.220.101.47
Subject: ACTION REQUIRED - VPN Credential Verification
```

---

## Question

Which header field is the strongest indicator that this email is part of a spearphishing attack?

---

## Flags (Choose One)

- **A)** The Message-ID format is non-standard
- **B)** The Reply-To address points to an external domain that is not company.internal
- **C)** The Subject line is written in all caps
- **D)** The Received header shows an internal IP, which is suspicious

---

Correct Flag: **B**

---

# Finished?
[Next Question](IS_medium.md)
[Back to Card's Main Page](../Internal_Spearphishing.md)
