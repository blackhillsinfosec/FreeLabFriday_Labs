![image](/FilesForLabs/images/blueantisyphon.png)

## Spotting the Rogue Device

During a site walkthrough, you inspect the server room. Everything looks normal at first glance - until you crouch down and check the back of the main switch. You find a small device plugged into port 14 with no asset tag, no label, and no entry in the hardware inventory.

You photograph it and pull the switch port logs:

```
Port 14 - Link UP: 03:47 AM
MAC: b8:27:eb:4c:2a:11
DHCP Lease granted: 192.168.1.201
Hostname: raspberrypi
```

The building access log shows no authorized personnel entered the server room between midnight and 6 AM.