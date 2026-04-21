![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Cloud IAM Escalation

You are reviewing an AWS environment with Prowler after a suspicious API call was logged by CloudTrail:

```
Event: iam:AttachUserPolicy
Actor: arn:aws:iam::941782301045:user/dev-ci-runner
Target: arn:aws:iam::941782301045:user/dev-ci-runner
Policy attached: arn:aws:iam::aws:policy/AdministratorAccess
Time: 2024-11-03T02:14:38Z
Source IP: 185.220.101.47
```

The `dev-ci-runner` account is a CI/CD service account used by the build pipeline. Its original policy allowed only `s3:GetObject` and `ecr:GetAuthorizationToken`.

Prowler also flags this in its output:

```
[HIGH] iam_policy_attached_no_admin_privileges
FAIL - dev-ci-runner has AdministratorAccess attached
```

---

## Question

What actually happened here, and what made this escalation possible in the first place?

---

## Flags (Choose One)

- **A)** The CI/CD account had `iam:AttachUserPolicy` permissions in its original policy, which allowed it to attach AdministratorAccess to itself - a classic IAM privilege escalation
- **B)** An insider threat manually logged into AWS Console and attached the policy through the UI
- **C)** Prowler misidentified the finding; `iam:AttachUserPolicy` is a standard CI/CD permission with no security impact
- **D)** The attacker exploited a vulnerability in the AWS IAM API to bypass policy restrictions

---

Correct Flag: **A**

---

# Finished?
[Back to Card's Main Page](/Cards/DET/Permissions_Audit.md)
