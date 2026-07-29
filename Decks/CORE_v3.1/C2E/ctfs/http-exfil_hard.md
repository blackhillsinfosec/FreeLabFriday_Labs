![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF – Full Exfiltration Investigation

During an incident review, you observe the following:

- A web server was compromised three days ago.
- Outbound HTTPS traffic increased slowly over time.
- Requests go to a cloud storage domain not used by the organization.
- Each request size is small, but continuous.
- Endpoint logs show a process archiving files before traffic spikes.

---

## Question

Which explanation best fits this behavior?

---

## Flags (Choose One)

- **A)** Legitimate backups running after a software update
- **B)** Web crawler indexing large amounts of content
- **C)** Data exfiltration using staged archives sent over normal HTTPS traffic
- **D)** Users downloading files from the website

---

Correct Flag: **C**

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/HTTP_As_Exfil.md)
