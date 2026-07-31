![image](/FilesForLabs/images/blueantisyphon.png)

# Hayabusa

# Ubuntu VM
### Lab Objective
The objective of this lab is to use Hayabusa to analyze Sysmon logs and detect suspicious activity related to process creation, network connections, and authentication events.

**If you want to learn a bit about this tool check the [Hayabusa Documentation](/SocAnalystLabs/courseFiles/tools/Hayabusa.md)**
<hr>

## Step 1: Set The Detection Rules
First things first navigate to Hayabusa at `/home/ubuntu/SOC_Analyst_Labs/hayabusa/labFile`

```bash
cd /home/ubuntu/SOC_Analyst_Labs/hayabusa/labFile
```

- To start off we need to make sure we have the detection rules of Hayabusa

```bash
hayabusa update-rules
```

<img width="619" height="172" alt="image" src="https://github.com/user-attachments/assets/b6f922fb-08fd-4c0c-9785-a17cfa410cfb" />

Make sure you are in the right place:

```bash
ls -lh sysmon.evtx
```

<img width="578" height="20" alt="image" src="https://github.com/user-attachments/assets/a1fe4145-6e22-4158-bb7f-01cb0e2f0fef" />

- First thing we will do to start dissecting the logs is to get some basic **metrics** to understand what system the logs came from, number of events, time range.

```bash
hayabusa log-metrics --file sysmon.evtx
```

<img width="921" height="705" alt="image" src="https://github.com/user-attachments/assets/a447aa87-eb2c-4894-a57c-a990f6cf7e1d" />

The logs span about 30 minutes and there are only 565 events, small enough to dig manually but we will do it the smart way.<br><br>

- Next let's see the Event **ID Distribution** to identify common or suspicious Sysmon events, we are looking for **1**, **3**, **10**, **11** or even **8**

```bash
hayabusa eid-metrics --file sysmon.evtx
```

<img width="699" height="668" alt="image" src="https://github.com/user-attachments/assets/f4a6c7e2-de68-4f4e-82da-0047b4865321" />

Important observations:
1. **Process Creation (ID 1 = 90%)**, that's extremely high volume, and now our primary hunting ground
2. **WMI Activity (IDs 19, 20, 21)**, rare in normal activities, could be remote execution
3. **Network Connections (ID 3)**, check what process made the connection, destination IP/port, and timing.<br><br>

- Now let's proceed with a **Full Timeline Analysis**

```bash
hayabusa csv-timeline --file sysmon.evtx -o timeline.csv
``` 
>[!TIP]
>
>(include all rules)

- Make sure to select the 5th options using arrows **Up** and **Down** and press **Enter** when the 5th option is highlighted

<img width="982" height="155" alt="image" src="https://github.com/user-attachments/assets/beb3d813-4521-48e0-9961-5877b6cfa94c" />

- Also select everything that is selected down below

<img width="467" height="92" alt="image" src="https://github.com/user-attachments/assets/c771bdaa-edb8-4156-8e20-95f047b658ad" />

<img width="951" height="1086" alt="image" src="https://github.com/user-attachments/assets/254078ea-bae1-470e-bbdd-e73831ad1486" />

Immediately we can see some really telling information, we got hits on 555 out of 565 events, 7 of them being critical alerts indicating a 'Sticky Key' type backdoor. There are also 49 'high' priority alerts.  

Let's dig deeper

```bash
less timeline.csv | grep "high"
```

One of the alerts looks like this:

<pre>"2019-07-19 14:57:04.412 +00:00","Proc Exec (Non-Exe Filetype)","high","MSEDGEWIN10","Sysmon",1,4070,"Cmdline: C:\Users\IEUser\AppData\Local\Temptcm.tmp -decode c:\file.exe file.txt ¦ Proc: C:\Users\IEUser\AppData\Local\Temptcm.tmp ¦ User: MSEDGEWIN10\IEUser ¦ ParentCmdline: cmd.exe /c C:\Users\IEUser\AppData\Local\Temptcm.tmp -decode c:\file.exe file.txt ¦ LID: 0x50951 ¦ LGUID: 747F3D96-D4B4-5D31-0000-002051090500 ¦ PID: 6260 ¦ PGUID: 747F3D96-DA40-5D31-0000-0010AB5F3C00 ¦ ParentPID: 3932 ¦ ParentPGUID: 747F3D96-DA40-5D31-0000-0010565D3C00 ¦ Description: CertUtil.exe ¦ Product: Microsoft® Windows® Operating System ¦ Company: Microsoft Corporation ¦ Hashes: SHA1=459D928381CDDFDC31D03C3DA5C28E63B1190194,MD5=535CF1F8E8CF3382AB8F62013F967DD8,SHA256=85DD6F8EDF142F53746A51D1DCBA853104BB0207CDF2D6C3529917C3C0FC8DF,IMPHASH=683B8A445B00A271FC57848D893BD6C4","CurrentDirectory: C:\AtomicRedTeam\ ¦ FileVersion: 10.0.17763.1 (WinBuild.160101.0800) ¦ IntegrityLevel: High ¦ ParentImage: C:\Windows\System32\cmd.exe ¦ RuleName: ¦ TerminalSessionId: 1 ¦ UtcTime: 2019-07-19 14:57:04.381","8d1487f1-7664-4bda-83b5-cb2f79491b6a"
</pre>
We get the command: "**C:\Users\IEUser\AppData\Local\Temptcm.tmp -decode c:\file.exe file.txt**" which is a classic Living-off-the-Land (LOLBAS) technique, certutil -decode is often used to decode base64-encoded payloads that were dropped by phishing or scripts

Why it's suspicious?
1. **CertUtil.exe** isn't normally used by regular users
2. Executing from AppData\Local with a .tmp file? Classic sign of malware staging
3. Suggests payload delivery step in malware chain

Following the chain we meet these commands:

**sc.exe create AtomicTestService binPath= C:\AtomicRedTeam\atomics\T1050\bin\AtomicService.exe** - Service Creation for Persistence

**sc.exe start AtomicTestService** - Service Execution

**sc.exe stop AtomicTestService** - Service Stop (Cleanup?)<br><br>

- We can also do some **Hunting Scenarios**, searching for special keywords

```bash
hayabusa search --file sysmon.evtx --regex '(?i)(cmd\.exe|powershell|whoami|mimikatz)'
```

<img width="1842" height="1067" alt="image" src="https://github.com/user-attachments/assets/412c74d8-78e6-44da-9785-c70408469b1c" />


Following up this lead we can get to the same results as earlier, or use it to group alerts by services, the possibilities are endless
<br><br>

## Your turn
>[!TIP]
>
> Try extracting any encrypted payloads and pulling authentication activity yourself, if there is any, using the documentation of the tool.

Also try finding everything you found in this lab by using [Windows Event Viewer](../tools/WinEventViewer.md)

> Created By Turcu Știolică Alexandru - Black Hills Information Security