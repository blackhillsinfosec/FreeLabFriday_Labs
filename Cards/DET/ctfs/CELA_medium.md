![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Privilege Escalation Trail

You are investigating a potential insider threat. A developer account triggered several alerts in your SIEM over two hours. Below is the condensed event timeline:

```
[09:12] IAMUser: dev-maria  ->  ListRoles            (Success)
[09:13] IAMUser: dev-maria  ->  ListPolicies          (Success)
[09:15] IAMUser: dev-maria  ->  GetPolicyVersion      (Success)
[09:31] IAMUser: dev-maria  ->  CreatePolicyVersion   (Success) <- new policy version sets Action: "*", Resource: "*"
[09:32] IAMUser: dev-maria  ->  SetDefaultPolicyVersion (Success)
[09:33] IAMUser: dev-maria  ->  AttachUserPolicy      (Success) <- policy attached to dev-maria
[09:47] IAMUser: dev-maria  ->  CreateUser            (Success) <- new user: "svc-backup-temp"
[09:48] IAMUser: dev-maria  ->  CreateAccessKey       (Success) <- key created for svc-backup-temp
[10:02] IAMUser: svc-backup-temp -> AssumeRole: AdminRole (Success)
```

The `dev-maria` account was supposed to have read-only access to EC2 resources only.

---

## Question

Looking at the sequence of events, what attack technique was used to gain administrator access?

---

## Flags (Choose One)

- **A)** dev-maria exploited an S3 bucket misconfiguration to extract admin credentials
- **B)** dev-maria used a stolen session token from another admin user
- **C)** dev-maria modified an IAM policy to grant herself full permissions, then created a secondary account to assume an admin role
- **D)** dev-maria triggered a Lambda function that automatically escalated privileges on a schedule

---

Correct Flag: **C**

---

# Finished?
[Next Question](CELA_hard.md)  
[Back to Card's Main Page](/Cards/DET/Cloud_Event_Log_Analysis.md)
