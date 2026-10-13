## Hunting the Exfil Channel

Your SIEM has triggered an alert on a developer's workstation. You pull the correlated events and find the following timeline:

```
[09:14:02] FILE ACCESS   python.exe  READ  C:\Projects\src\db_config.py
[09:14:02] FILE ACCESS   python.exe  READ  C:\Projects\src\api_keys.json
[09:14:03] FILE ACCESS   python.exe  READ  C:\Projects\deploy\prod_credentials.env
[09:14:05] NETWORK       python.exe  CONNECT  slack.com:443
[09:14:06] NETWORK       python.exe  POST  https://hooks.slack.com/services/T04XXX/B07XXX/XXXXXXX
[09:14:06] NETWORK       python.exe  BYTES_OUT: 87,412
```

The developer has a Python environment set up, but no Slack bots or automation scripts were approved for this machine. The Slack webhook URL in the logs does not match any internal workspace the company uses.
