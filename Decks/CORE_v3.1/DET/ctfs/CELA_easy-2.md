## Noisy API

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
