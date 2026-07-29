![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Credential Stuffing Investigation

You are investigating a suspected account takeover campaign.

Data summary:

```
- 18,000 failed logins over 24 hours
- Success rate: 1.8%
- Successful logins spread across many countries
- Sessions show immediate password change attempts
- Many accounts had passwords previously seen in breach data
```

Additional context:
- MFA was optional and disabled on most affected accounts.
- The attackers stopped once passwords were changed.

---

## Question

Which defensive control would have most directly reduced the impact of this attack?

---

## Flags (Choose One)

- **A)** Increasing web server CPU resources
- **B)** Enforcing multi-factor authentication (MFA)
- **C)** Hiding the login page URL
- **D)** Disabling account registration

---

Correct Flag: **B**

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Credential_Stuffing.md)
