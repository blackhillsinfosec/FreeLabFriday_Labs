![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Tainted Package

A developer pulls in a popular open-source logging library for their Node.js project. They run `npm install` and the package installs without errors. A week later, the security team notices outbound traffic to an unknown IP coming from that same server.

The package version installed was `logger-utils@2.3.1`. The official version on the registry is `logger-utils@2.3.0`.

---

## Question

What most likely explains the situation?

---

## Flags (Choose One)

- **A)** The developer made a typo in the package name and installed a different package
- **B)** The npm registry had a caching issue that served an outdated version
- **C)** The server's firewall was misconfigured and allowed outbound traffic by default
- **D)** An attacker published a malicious version of the package with a bumped version number


---

Correct Flag: **D**

---

# Finished?

[Next Question](TPMI_easy-2.md)
[Back to Card's Main Page](../Third-Party_Malware_Injection.md)
