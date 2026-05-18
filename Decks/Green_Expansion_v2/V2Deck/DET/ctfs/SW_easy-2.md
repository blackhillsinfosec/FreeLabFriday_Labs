![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Reading the Badge Logs

You are reviewing badge reader logs after a walkthrough flagged an unlocked server room door. The door should require badge access at all times.

The log for the past 24 hours shows:

```
08:14 AM - Badge #0042 - GRANTED - John M.
08:15 AM - Badge #0042 - GRANTED - John M.
08:15 AM - Badge #0042 - GRANTED - John M.
08:16 AM - Badge #0042 - GRANTED - John M.
...
08:19 AM - Badge #0042 - GRANTED - John M.
11:03 AM - Badge #0091 - GRANTED - Sarah K.
11:04 AM - Door held open - ALERT (45 sec)
```

John M. is on vacation this week and has not been to the office.

---

## Question

What does the badge log most likely indicate?

---

## Flags (Choose One)

- **A)** John M. forgot to log out of the building system before his vacation
- **B)** The badge reader malfunctioned and logged duplicate entries
- **C)** Someone cloned John M.'s badge and used it to gain repeated access
- **D)** Sarah K. triggered a door-held alert by leaving the door open too long

---

Correct Flag: **C**

---

# Finished?

[Next Question](SW_medium.md)
[Back to Card's Main Page](../Site_Walkthrough.md)
