![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Rule

A user calls the help desk saying they never received a password reset email they requested. You log into the admin panel and pull up their mailbox rules.

You find this rule configured on their account:

```
Rule Name: (no name)
Condition: Subject contains "password" OR "reset" OR "verify"
Action: Delete permanently
Run on: All incoming mail
Created: 2024-11-03 02:14 AM
```

The user says they have never set up any inbox rules.
