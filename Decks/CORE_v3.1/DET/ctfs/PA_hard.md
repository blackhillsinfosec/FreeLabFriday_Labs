## Cloud IAM Escalation

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
