![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious Vendor Login

You are reviewing authentication logs after a partner account triggered an alert.

You find the following entries:

```
03:12  login_success  account=vendor_sync
03:13  download       file=finance_export.csv
03:14  login_success  account=vendor_sync
03:14  source_ip=185.77.21.44
03:15  disable_mfa    account=vendor_sync
```

The vendor normally connects from a fixed corporate IP range and never changes security settings.
