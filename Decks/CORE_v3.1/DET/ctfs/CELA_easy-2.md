![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Noisy API

You are reviewing Wazuh alerts for a cloud-connected environment. Over a 10-minute window, you see the following API calls all originating from the same access key:

```
ListBuckets
ListBuckets
ListBuckets
DescribeInstances
DescribeInstances
ListUsers
ListRoles
ListPolicies
GetAccountAuthorizationDetails
ListAttachedUserPolicies
```

All calls were made successfully. The access key belongs to a service account used by a billing automation script. That script normally runs once a day and only calls `GetCostAndUsageReport`.

---

## Question

What does this activity most likely indicate?

---

## Flags (Choose One)

- **A)** The billing script is working correctly and pulling cost data
- **B)** An automated AWS health check is scanning the account
- **C)** The access key was compromised and an attacker is enumerating the environment
- **D)** A developer is testing new IAM permissions for the service account

---

Correct Flag: **C**

---

# Finished?
[Next Question](CELA_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Cloud_Event_Log_Analysis.md)
