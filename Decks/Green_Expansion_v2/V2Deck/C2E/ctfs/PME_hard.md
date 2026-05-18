![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Exfil Chain

During a red team engagement, you are reviewing the findings report. The red teamers documented the following chain of events:

```
Day 1 - 08:14
  Operative tailgated through a side entrance during morning rush.
  Sat at an empty desk in an open workspace area.
  Plugged a Raspberry Pi Zero into the back of an unlocked workstation via USB.
  Device configured to emulate a USB keyboard (HID attack).
  Script ran silently: opened PowerShell, staged a compressed archive of Documents/
  and Desktop/ to a hidden folder on C:\.

Day 1 - 08:17
  Operative left the building.

Day 3 - 11:40
  Operative returned, again via tailgate.
  Plugged a USB flash drive into the same workstation (still unlocked, same desk).
  Copied the staged archive (4.1 GB) to the drive.
  Unplugged and left. Total time on site: 4 minutes.

No alerts fired across either visit.
No badge swipes recorded for the operative.
Workstation had no USB device restrictions.
No cameras covered that section of the open workspace.
```

---

## Question

The red team split the operation into two separate visits instead of doing everything in one go. What is the most accurate reason this approach was effective from a stealth perspective?

---

## Flags (Choose One)

- **A)** Splitting visits reduced the total amount of data exfiltrated, staying under DLP thresholds
- **B)** The first visit used a HID device that never appeared as storage, avoiding USB storage alerts, while the second visit only needed a brief plug-in to grab pre-staged data - keeping each interaction short and low-risk
- **C)** The Raspberry Pi encrypted the data on day one, making it undetectable to antivirus on day three
- **D)** Two visits confused the SIEM correlation rules by creating non-consecutive log entries

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](../Physical_Medium_as_Exfil.md)
