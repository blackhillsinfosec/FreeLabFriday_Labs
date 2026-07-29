![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Full Incident Reconstruction

You are conducting a post-incident review after a major breach. Your job is to reconstruct the timeline and identify where the response **failed**. Read the following sequence of events carefully.

---

## Timeline

| Time | Event |
|------|-------|
| 08:03 | Phishing email delivered to employee `jsmith` |
| 08:21 | `jsmith` clicks link, malware executes on `WKSTN-07` |
| 08:45 | Malware beacons out to C2 server — **no alert fires** |
| 09:10 | Attacker begins credential dumping on `WKSTN-07` |
| 09:34 | Attacker uses harvested credentials to log into `SRV-FILESTORE-01` |
| 10:02 | 40GB of data starts transferring to an external IP |
| 10:47 | SIEM fires alert: *"Unusual outbound data volume"* |
| 10:51 | SOC analyst sees alert, marks it as *"likely false positive"*, closes ticket |
| 11:30 | Attacker completes exfiltration, removes traces |
| 14:20 | A different analyst notices the closed alert and escalates |
| 14:45 | IR team engaged — attacker has been gone for nearly 3 hours |

---

## Question

The IR team is writing the post-incident report. They need to identify the **single point in this timeline where proper Crisis Management procedure, if followed, would have had the greatest impact on limiting damage**.

---

## Flags (Choose One)

- **A)** 08:03 - The phishing email should have been blocked by the email gateway before delivery
- **B)** 10:51 - The SOC analyst incorrectly dismissed a valid alert during active exfiltration; escalation at this point would have stopped the data transfer before completion
- **C)** 09:10 - Endpoint protection should have caught the credential dumping in real time
- **D)** 14:20 - The second analyst should have escalated faster after finding the closed ticket

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Crisis_Management.md)
