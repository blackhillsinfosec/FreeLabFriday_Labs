## Full Incident Reconstruction

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
