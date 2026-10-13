![image](/FilesForLabs/images/blueantisyphon.png)

## Spotting the Tampered Update

Your company uses an enterprise IT management platform. The security team flagged an alert after the latest update was pushed to all endpoints.

You pull the following information from the update manifest:

```
Package:        OrionPlatform-v2.1.4.exe
Vendor:         SolarWinds
Digital Signature: VALID
SHA256 (expected):  a1b2c3d4e5f6...
SHA256 (actual):    a1b2c3d4e5f6...
Size (expected):    48.2 MB
Size (actual):      48.2 MB
Installed:      Yes
Post-install behavior: Outbound connection to upd-svc.solarwinds-cdn[.]net:443
```

The hashes match. The signature is valid. But one thing stands out.
