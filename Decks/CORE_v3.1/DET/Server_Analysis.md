<img width="300" height="414" alt="BNB_CARDS_v3_33" src="https://github.com/user-attachments/assets/5f06566c-d7d1-47c1-b9ae-5694b19c8a6c" />

# Server Analysis

A server is considered **compromised** when someone gains access or control without authorization. This doesn’t always mean the attacker fully owns the machine - sometimes they only have a limited foothold - but even small access can be dangerous if it goes unnoticed.

Server analysis is the process of looking at system behavior, logs, and configurations to figure out what is happening, what already happened, and whether something abnormal is taking place.

Because servers run critical services and are constantly exposed to networks, they are common targets during real intrusions.

---

## How Servers Become Compromised

Most compromises follow a familiar pattern:

- Attackers scan for exposed services or weak configurations  
- They find a vulnerability or stolen credentials  
- Initial access is gained through exploitation or misuse of access  
- Malicious tools or scripts are deployed  
- The attacker tries to stay hidden and maintain access  

Common causes include:

- Unpatched services or outdated software  
- Weak authentication or reused passwords  
- Misconfigured permissions or exposed management ports  
- Vulnerable applications running on the server  
- Lack of monitoring or logging visibility  

---

## What Attackers Do After Access

After gaining access, attackers usually focus on three goals: control, persistence, and movement.

Typical actions include:

- Running suspicious processes or scripts  
- Creating hidden accounts or scheduled tasks  
- Downloading additional tools  
- Moving laterally to other systems  
- Exfiltrating data or credentials  
- Using the server as infrastructure for further attacks  

This stage often leaves traces in logs, process activity, and network traffic - which is why analysis matters.

---

## What Server Analysis Looks For

Defenders analyze servers to answer simple questions:

- What changed?  
- Who or what made the change?  
- Is activity normal for this system?  
- Are there signs of persistence or abuse?  

Key areas typically reviewed:

- Authentication and system logs  
- Running processes and services  
- Network connections and unusual traffic  
- File and configuration changes  
- System performance anomalies  

Good analysis is less about guessing and more about building a timeline from evidence.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/detections/server-analysis?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Suspicious Login Activity](ctfs/SA_easy-1.md)  
- [Easy 2 – Strange Process Discovery](ctfs/SA_easy-2.md)  
- [Medium – Log Correlation Investigation](ctfs/SA_medium.md)  
- [Hard – Full Incident Timeline Reconstruction](ctfs/SA_hard.md)  
-->
---

## Labs

Hands-on labs based on the tools used for server analysis.

- [DeepBlueCLI Lab](https://freelabfridays.com/labs/introclassfiles/tools/introclass/deepbluecli/deepbluecli/)  
- [Velociraptor Lab](https://freelabfridays.com/labs/introclassfiles/tools/introclass/velociraptor/velociraptor/)  
- [Sysinternals Suite Lab](https://freelabfridays.com/comingsoon/)  

---

Server analysis is about understanding behavior, not memorizing commands. The faster you can recognize what “normal” looks like, the easier it becomes to spot when something is wrong.
