## Event Log Review

You are reviewing Windows Security Event logs on a server after an after-hours alert. You notice the following sequence of events:

```
[2024-11-14 02:13:41]  EventID: 4625  Account: administrator  Logon Type: 3  Result: FAILURE
[2024-11-14 02:13:42]  EventID: 4625  Account: administrator  Logon Type: 3  Result: FAILURE
[2024-11-14 02:13:43]  EventID: 4625  Account: administrator  Logon Type: 3  Result: FAILURE
[2024-11-14 02:13:44]  EventID: 4625  Account: administrator  Logon Type: 3  Result: FAILURE
[2024-11-14 02:13:45]  EventID: 4624  Account: administrator  Logon Type: 3  Result: SUCCESS
[2024-11-14 02:14:02]  EventID: 4720  Account: backdoor_user  Performed by: administrator
```
