![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Spotting the Rogue Device

During a site walkthrough, you inspect the server room. Everything looks normal at first glance - until you crouch down and check the back of the main switch. You find a small device plugged into port 14 with no asset tag, no label, and no entry in the hardware inventory.

You photograph it and pull the switch port logs:

```
Port 14 - Link UP: 03:47 AM
MAC: b8:27:eb:4c:2a:11
DHCP Lease granted: 192.168.1.201
Hostname: raspberrypi
```

The building access log shows no authorized personnel entered the server room between midnight and 6 AM.

---

## Question

What is the most likely explanation for the device on port 14?

---

## Flags (Choose One)

- **A)** A network technician left a testing device plugged in
- **B)** A rogue device was planted by an unauthorized person for persistent access
- **C)** The switch automatically provisioned a new virtual port
- **D)** A legitimate backup server came online after a scheduled reboot

---

Correct Flag: **B**

---

# Finished?

[Next Question](SW_easy-2.md)
[Back to Card's Main Page](../Site_Walkthrough.md)
