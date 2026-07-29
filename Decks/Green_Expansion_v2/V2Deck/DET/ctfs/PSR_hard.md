![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Full Physical Intrusion Simulation

You are a red team operator tasked with gaining access to the internal network of a financial firm. You have been given permission to test physical controls only - no digital exploitation until you are physically inside.

**Reconnaissance notes collected over three days:**

```
- Building has two entrances: main lobby (guarded 07:00-19:00) and a side entrance (badge only, no guard)
- Side entrance RFID reader model: HID iCLASS SE - known to be vulnerable to relay attacks at close range
- Employees use a smoking area at the back of the building, 11:30-12:00 daily
- A "Staff Only" door near the smoking area is frequently propped open during lunch
- Dumpster near loading dock contains unshredded documents - found org chart and internal phone list
- IT helpdesk number is printed on documents recovered from dumpster
- Badge design visible in a LinkedIn photo posted by an employee - blue card, gold logo, no hologram
```

**On the day of the test, you call the helpdesk posing as a new employee:**

> "Hi, I just started this week in the Croydon branch and I was told to come in for an onboarding session today, but my badge is not working at the side entrance. Can someone let me know if there is a temporary access code or if I should go around front?"

The helpdesk rep gives you a four-digit door code for the side entrance used during badge reader maintenance.

---

## Question

You now have the door code and a cloned badge design. You want to reach the server room on Floor 2 with the lowest chance of detection. Ordering the steps below - which sequence is correct?

```
1. Enter through the side entrance using the door code during lunch hour
2. Clone a staff badge using the org chart and a relay attack at the smoking area
3. Use the cloned badge to open the Floor 2 server room door
4. Tailgate through the "Staff Only" propped door near the smoking area
5. Wait in a bathroom stall until the floor is quiet
```

---

## Flags (Choose One)

- **A)** 2 -> 1 -> 4 -> 5 -> 3
- **B)** 1 -> 4 -> 5 -> 2 -> 3
- **C)** 2 -> 4 -> 1 -> 3 -> 5
- **D)** 1 -> 2 -> 4 -> 3 -> 5

---

Correct Flag: **A**

---

# Finished?

[Back to Card's Main Page](../Physical_Security_Review.md)
