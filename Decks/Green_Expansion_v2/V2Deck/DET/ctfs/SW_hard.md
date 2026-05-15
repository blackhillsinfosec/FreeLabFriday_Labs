![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Physical Intrusion Timeline

A security alert was triggered at 2:30 AM by an IDS rule. Your team conducts a full site walkthrough the next morning. You pull data from every available source and piece together the following:

**Badge Logs:**
```
01:52 AM - Badge #0017 - GRANTED - Maintenance (rear entrance)
02:01 AM - Server Room Door - GRANTED - Badge #0017
02:28 AM - Server Room Door - GRANTED - Badge #0017
02:29 AM - Rear Entrance - GRANTED - Badge #0017 (exit)
```

**CCTV (rear entrance camera):**
```
01:52 AM - One individual enters. Wearing a high-visibility vest and carrying a bag.
           Face partially obscured by cap. No second individual present.
02:29 AM - Same individual exits. Bag appears heavier/fuller than on entry.
```

**CCTV (server room - internal):**
```
02:01 AM - 02:27 AM - No footage. Camera offline (manual power disconnect recorded).
```

**Wireless Spectrum Scan (conducted during walkthrough):**
```
New SSID detected: "SRV-MGMT-01" | MAC: DC:A6:32:00:F1:44 | Signal: -41 dBm
Device not in inventory. Located inside rack 3B.
```

**Written Equipment Log (server room):**
```
Last signed entry: 4:15 PM previous day - Rack inspection, all equipment accounted for.
No entries between 4:15 PM and morning walkthrough.
```

**IDS Alert (02:30 AM):**
```
Outbound connection to 185.220.101.47:4444
Source: 192.168.10.55 (newly assigned DHCP lease - no prior history)
Protocol: TCP - reverse shell pattern detected
```

---

## Question

Based on all available evidence, which of the following best describes what happened during the intrusion?

---

## Flags (Choose One)

- **A)** An attacker used a cloned or stolen maintenance badge to access the server room, disabled the CCTV manually to avoid recording, planted a rogue device in rack 3B, and left before the IDS alert fired - the alert was triggered by the planted device establishing a reverse shell
- **B)** An authorized maintenance worker entered to replace hardware, accidentally knocked out the CCTV power, and a pre-existing infected device triggered the IDS alert independently
- **C)** A legitimate vendor visit was not logged properly - the CCTV outage was a known technical fault, and the IDS alert was a false positive from a misconfigured monitoring tool
- **D)** A disgruntled insider accessed the server room using their own valid badge, took equipment from the racks, and the IDS alert was triggered by a different unrelated host on the network

---

Correct Flag: **A**

---

# Finished?

[Back to Card's Main Page](../Site_Walkthrough.md)
