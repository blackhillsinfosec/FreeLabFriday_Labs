![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Spotting the Tampered Update

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

---

## Question

What is the most likely indicator that this update was tampered with?

---

## Flags (Choose One)

- **A)** The file size did not match the expected value
- **B)** The digital signature was invalid
- **C)** The SHA256 hash did not match the expected value
- **D)** The update made an unexpected outbound network connection after installation

---

Correct Flag: **D**

---

# Finished?

[Next Challenge](SCA_easy-2.md)
[Back to Main Page](../Supply_Chain_Attack.md)
