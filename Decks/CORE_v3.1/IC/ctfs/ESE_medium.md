## Pick the Exploit Path

During recon, you fingerprint a public-facing VPN appliance

Nmap + banner info:

```
443/tcp open  https
Service: SSL VPN Portal
Vendor hint: "Fortinet"
Observed version string: "FortiOS 7.0.x" (from page source)
```

You search your notes and find two items:

1) A known vulnerability affects **some** FortiOS SSL-VPN builds (RCE/unauth access style bugs exist historically)
2) Your rules of engagement allow exploitation **only after** you confirm the exact affected build/version

---

## Goal

Choose the best **responsible** red-team step that still moves you toward an initial foothold quickly
