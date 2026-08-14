<img width="300" height="414" alt="BNB_CARDS_v3_25" src="https://github.com/user-attachments/assets/5f304c2b-8a3f-44e4-add1-2c4cfeb38182" />

# Malicious Firmware

Firmware is the low-level software baked into hardware - your BIOS, UEFI, network cards, video cards, and more. It runs before the operating system even loads, which makes it incredibly powerful. And incredibly dangerous when tampered with.

When an attacker replaces legitimate firmware with a malicious version, they get a foothold that sits below everything else on the machine. Reinstalling Windows won't fix it. Wiping the drive won't fix it. It just keeps coming back.

---

## What Firmware Actually Is

Every piece of hardware needs instructions to operate. Those instructions live in a small chip on the device itself - that's the firmware. The most well-known examples are:

- **BIOS / UEFI** - the first code that runs when you power on a machine, responsible for initializing hardware and handing off to the OS
- **Network Interface Cards (NICs)** - have their own firmware that controls how packets are handled
- **GPUs** - also carry flashable firmware

Because firmware runs at such a low level, it has access to almost everything. An attacker who controls your UEFI controls your machine in ways that no antivirus or EDR can fully see.

---

## How Attackers Get There

Flashing malicious firmware isn't something that happens by accident. It usually requires either physical access to the machine or an already-compromised OS. Common paths include:

- Gaining admin/root access first, then using tools to reflash firmware from within the OS
- Supply chain attacks, where hardware arrives already compromised
- Using tools like **Flashrom** or **Impacket** to interact with hardware interfaces remotely
- Exploiting poor or missing Secure Boot configurations

Once firmware is replaced, the attacker's code runs every boot cycle, often before any security software has a chance to load.

---

## Why It's So Hard to Detect

Most security tools operate at the OS level. Malicious firmware lives below that. This creates a blind spot that is genuinely difficult to close. A few things make detection harder:

- The compromised firmware may look valid and even pass basic integrity checks if the attacker was careful
- Many organizations don't monitor firmware versions at all
- Not all hardware supports firmware verification out of the box

Detection relies on tools like **CHIPSEC**, which can inspect chip configurations and look for unauthorized changes, combined with memory analysis and endpoint telemetry.

---

## What Attackers Can Do With It

A machine with compromised firmware can be made to:

- Persist through full OS reinstalls and disk wipes
- Exfiltrate data before the OS even boots
- Disable security features like Secure Boot
- Act as a persistent backdoor into a network, surviving incident response

This technique shows up in nation-state level attacks and advanced persistent threat (APT) campaigns. It's not common in everyday intrusions, but when it appears, it signals a very determined and capable adversary.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/persistence/malicious-firmware?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Firmware String Extraction](ctfs/MF_easy-1.md)
- [Easy 2 – UEFI Boot Anomaly](ctfs/MF_easy-2.md)
- [Medium – Flash Memory Tampering](ctfs/MF_medium.md)
- [Hard – Full Firmware Implant](ctfs/MF_hard.md)
-->
---

## Labs

Hands-on practice with the tools from the card:

- [Flashrom Lab](https://freelabfridays.com/labs/decks/core-v31/per/labs/flashrom/)
- [Impacket Lab](https://freelabfridays.com/labs/decks/core-v31/per/labs/impacket/)
- [PowerShell Lab](https://freelabfridays.com/labs/decks/core-v31/labs/powershell/)
- [Metasploit Lab](https://freelabfridays.com/labs/decks/core-v31/labs/metasploit/)

---

Malicious firmware attacks are rare, but they represent some of the most persistent and stealthy techniques in existence. Understanding how they work - even at a conceptual level - changes how you think about what "fully compromised" actually means.