![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Social Engineering Scenario

You are reviewing an incident report. A USB drive was found plugged into a workstation in the accounting department. The drive contained a keylogger. CCTV footage and badge logs are available.

**Badge log excerpt - accounting floor, that day:**

```
08:14 - Employee ID 2241 - ENTRY
08:31 - Employee ID 0094 - ENTRY
09:02 - UNKNOWN - no badge scan recorded, door opened from inside
09:03 - Visitor badge V-17 - logged at reception desk
11:45 - Employee ID 2241 - EXIT
11:46 - Employee ID 0094 - EXIT
11:47 - Visitor badge V-17 - EXIT
```

**CCTV notes:**

- At 09:01, an employee held the door open for someone carrying a box
- The person with the box was not wearing a visitor lanyard
- Visitor badge V-17 was signed in at 09:03 as "HVAC contractor"
- The accounting workstation is located near the entrance, visible from the hallway

**Reception log:**

- V-17 signed in by receptionist at 09:03
- No escort was assigned
- V-17 was not accompanied at any point during the visit

---

## Question

Which combination of policy failures most directly allowed this incident to happen?

---

## Flags (Choose One)

- **A)** Weak passwords on workstations and no screen lock policy
- **B)** No visitor escort policy and an employee holding the door open without checking identity
- **C)** The badge system did not log the 09:02 entry and IT was not notified
- **D)** The CCTV system failed to alert security in real time when a tailgate was detected

---

Correct Flag: **B**

---

# Finished?

[Next Question](PSR_hard.md)

[Back to Card's Main Page](../Physical_Security_Review.md)
