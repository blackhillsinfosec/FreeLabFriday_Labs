![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Supply Chain Access Abuse

An investigation begins after unusual cloud activity appears in logs.

You observe:

```
api_key_owner=vendor-automation
new_keys_created=5
region_changes=multiple
security_group_rules=0.0.0.0/0 added
logs_disabled=true
```

The vendor integration is supposed to upload reports only once per day.

---

## Question

What is the strongest indicator that this is a supply-chain style compromise?

---

## Flags (Choose One)

- **A)** API activity occurred during business hours
- **B)** A legitimate integration created extra logs
- **C)** The vendor rotated its own credentials
- **D)** Trusted vendor credentials were used to weaken security controls

---

Correct Flag: **D**

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Trusted_Relationship.md)
