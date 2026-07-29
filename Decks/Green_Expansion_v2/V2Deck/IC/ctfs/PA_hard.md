![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Full Facility Breach

You are a security analyst conducting a post-incident review. Over three days, your team has pieced together the following timeline:

**Day 1 - Monday, 09:10 AM**
An unknown individual is spotted on lobby CCTV standing near the elevator bank, never badging in. He leaves after 20 minutes.

**Day 1 - Monday, 04:55 PM**
Badge access logs show Employee ID 2231 (a senior sysadmin) badging out. CCTV shows two people leaving through the turnstile at the same time, but only one badge scan is recorded.

**Day 2 - Tuesday, 11:42 PM**
A door alarm is triggered on the east stairwell fire exit. It is logged as a "brief open event" and automatically cleared by the monitoring system 8 seconds later. No guard is dispatched.

**Day 3 - Wednesday, 02:17 AM**
An internal camera in the server corridor captures a figure sliding a flat tool under the door of Server Room B, manipulating the interior handle. Entry takes approximately 90 seconds. The figure is wearing no identifiable uniform.

**Day 3 - Wednesday, 06:50 AM**
A sysadmin reports that a workstation in Server Room B was rebooted. A bootable USB drive is found still plugged in. Forensics confirms a full image of the internal drive was taken overnight.

---

## Question

Based on the full timeline, which statement best describes the attack chain and why the breach was not stopped earlier?

---

## Flags (Choose One)

- **A)** The attacker forced entry through the fire exit on Day 2 and was not detected because CCTV was offline that night
- **B)** The attacker performed reconnaissance on Day 1, tailgated out with an employee to map exit points, used the fire exit gap on Day 2 to confirm alarm response times, and on Day 3 used an under-the-door tool to bypass the server room lock - the breach continued undetected because each individual event appeared minor and was not correlated
- **C)** The attacker cloned badge ID 2231 on Day 1 and used it to access Server Room B on Day 3, but the badge system failed to log the entry
- **D)** A malicious insider with legitimate access copied the drive on Day 3 and staged the USB and UTD evidence to frame an outsider

---

Correct Flag: **D**

---

# Finished?

[Back to Card's Main Page](../Physical_Access.md)
