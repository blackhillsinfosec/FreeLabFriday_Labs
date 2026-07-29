![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Suspicious Extension

A user reports their browser is behaving strangely. You pull a list of installed Chrome extensions from their machine and find the following entry:

```
Name:        PDF Converter Pro
ID:          mhjfbmdgcfjbbpaeojofohoefgiehjai
Permissions: tabs, cookies, webRequest, webRequestBlocking, storage, <all_urls>
Installed:   via external registry key (not Chrome Web Store)
Last update: 3 days ago
```

The user says they never installed this extension and does not recognize it.

---

## Question

Which detail is the strongest indicator that this extension is malicious?

---

## Flags (Choose One)

- **A)** The extension has access to cookies and all URLs combined with a silent install method
- **B)** The extension was updated 3 days ago
- **C)** The extension name sounds like a legitimate utility
- **D)** The extension is listed with an ID instead of a display name

---

Correct Flag: **A**

---

# Finished?
[Next Question](MBP_easy-2.md)

[Back to Card's Main Page](../Malicious_Browser_Plugins.md)
