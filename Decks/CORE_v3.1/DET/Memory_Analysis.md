<img width="300" height="414" alt="BNB_CARDS_v3_43" src="https://github.com/user-attachments/assets/3de50706-67c2-4185-9e8d-eb005ac690d6" />

# Memory Analysis

When a system gets compromised, attackers leave traces. Not always on disk - sometimes only in memory. **Memory analysis** (also called memory forensics) is the process of pulling a snapshot of a running system's RAM and digging through it to find what was actually happening at that moment.

It is one of the most powerful techniques in incident response because memory holds things that never touch the filesystem: running processes, injected code, decrypted credentials, active network connections, and more.

---

## Why Memory Matters

Most attackers know that files on disk get flagged. Modern malware runs entirely in memory - it loads, does its job, and leaves no file behind. This is called a **fileless attack**.

If you only look at the hard drive during an investigation, you might find nothing. The memory tells a different story.

A RAM snapshot captures the system exactly as it was - every process, every network socket, every loaded DLL, every string that was decrypted at runtime. That is why defenders pull memory from suspect machines before anything else.

---

## What You Are Actually Looking For

When analyzing memory, the goal is to find anomalies - things that should not be there, or things that are hiding:

- **Processes with no parent**, or with names that look like system processes but are not
- **Injected code** sitting inside a legitimate process (like explorer.exe or svchost.exe)
- **Open network connections** to suspicious external IPs
- **Loaded modules** that are not mapped to any file on disk
- **Credentials and keys** that were decrypted at runtime and are still sitting in RAM

Most of this would be invisible if you only looked at logs or disk artifacts.

---

## How Attackers Get to This Point

Before memory analysis becomes relevant, an attacker has already gotten in. Common paths:

- Phishing email with a malicious attachment that executes a payload
- Exploitation of a vulnerable service exposed to the internet
- Supply chain compromise - something trusted delivers the malware
- Lateral movement from another already-compromised machine

Once the attacker has a foothold, they typically inject into a running process to stay hidden and blend in with normal activity. That injection lives in memory.

---

## How Memory Is Collected

You cannot just copy RAM like a file. It requires a dedicated acquisition tool that reads physical memory and saves it as an image. Common formats are `.raw`, `.lime` (Linux), `.vmem` (virtual machines), and `.dmp` (Windows crash dumps).

For VMs, you can also suspend the machine and grab the memory file directly from the hypervisor - useful in lab environments.

Once you have the image, analysis tools parse it against OS profiles to make sense of the raw bytes.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/detections/memory-analysis?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Process Hunt](ctfs/MA_easy-1.md)
- [Easy 2 – String Extraction](ctfs/MA_easy-2.md)
- [Medium – Injected Process](ctfs/MA_medium.md)
- [Hard – Full Memory Investigation](ctfs/MA_hard.md)
-->
---

## Labs

Hands-on practice with the tools from the card:

- [Volatility Lab](https://freelabfridays.com/labs/introclassfiles/tools/introclass/memory/memoryanalysisvolatility/)
- [Velociraptor Lab](https://freelabfridays.com/labs/introclassfiles/tools/introclass/velociraptor/velociraptor/)

---

Memory analysis is one of those skills that separates a thorough investigation from a shallow one. Disk artifacts can be wiped. Memory captures a moment in time that attackers rarely think to clean up.
