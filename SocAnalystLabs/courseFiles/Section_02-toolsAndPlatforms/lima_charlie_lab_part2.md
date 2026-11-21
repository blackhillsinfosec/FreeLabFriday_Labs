![image](/FilesForLabs/images/blueantisyphon.png)

# **Lima Charlie meets Atomic Red**

---

### **Part 2 of 2**

> [!TIP]
> Please complete [Part 1](./lima_charlie_lab_part1.md) before starting this lab.

In this lab, we will run a **controlled adversary simulation** with **Atomic Red Team** and use **LimaCharlie** to observe endpoint activity and investigate detections.

> [!IMPORTANT]
> Use only your **Windows lab VM**, not your personal or work computer. Some Atomic Red Team tests change system settings or download files.

---

### **Step 1: Enable Atomic Red Team and Sigma**

Continue from Part 1 in the **LimaCharlie** web interface. Open **Add-ons**:

<img width="1850" height="697" alt="image" src="https://github.com/user-attachments/assets/524fe8fa-e11d-4b2e-a107-6b228bbdd83f" />

Find and select **Atomic Red Team** (`ext-atomic-red-team`):

<img width="1301" height="812" alt="image" src="https://github.com/user-attachments/assets/f06eae01-9c5b-4483-80f8-a1dfffae7048" />

Click **Subscribe** for your organization. The extension lets us execute small tests mapped to the **MITRE ATT&CK** framework.

<img width="1511" height="433" alt="image" src="https://github.com/user-attachments/assets/fb7f4232-8c33-4a2b-8b32-0d43fd0d0018" />

**Stay in Add-ons.** Return to the Marketplace search, type **Sigma**, and select **`ext-sigma`**.

<img width="1334" height="508" alt="image" src="https://github.com/user-attachments/assets/843026f8-5ce5-4851-890f-196606a7f88a" />

Click **Subscribe** for your organization:

<img width="1505" height="520" alt="image" src="https://github.com/user-attachments/assets/4b54cc92-91f6-4695-a772-728eaa1a2ed6" />

> [!TIP]
> **Sigma** provides a managed set of open-source, vendor-neutral detection rules and is marked **Free** in the Marketplace. **Soteria EDR** is a separate managed ruleset shown at **$0.50 / vSensor / month**. You only need **Atomic Red Team and Sigma** for this lab.

You can now leave **Add-ons**. We will also build two custom **Detection & Response (D&R)** rules.

---

### **Step 2: Configure Detection Rules**

A **telemetry event** records something that happened; a **detection** is generated when a rule matches an event. Open your organization and select the Windows sensor installed in Part 1:

<img width="1849" height="591" alt="image" src="https://github.com/user-attachments/assets/fe4d311a-cbbc-4138-919e-c566d29c2333" />
<img width="1813" height="511" alt="image" src="https://github.com/user-attachments/assets/0574d16d-a322-43d8-80c6-9136be21ca31" />

Open **Detections** to explore the detection view. At first, it may show **No detections yet**:

<img width="994" height="652" alt="image" src="https://github.com/user-attachments/assets/5e0ed557-1de3-4c8a-a4b6-4163cfd8a2bc" />

**Create your own rules** -> Click on *Go To Detection & Response Rules*.

<img width="822" height="421" alt="image" src="https://github.com/user-attachments/assets/9720107a-d98f-4fae-af41-084d4d22ea66" />

Click **ADD RULE**:

<img width="1538" height="679" alt="image" src="https://github.com/user-attachments/assets/96454c20-1b94-47f7-946d-d7c4bb2d954e" />

A D&R rule has a **Detect** section (when to match) and a **Respond** section (what to do). We use `report` to generate alerts, not to block activity.

<img width="1517" height="834" alt="image" src="https://github.com/user-attachments/assets/bd441e4e-6be0-4129-b5fd-b557feac45cc" />

### **RULE A — Suspicious C# Compiler (`csc.exe`)**

Attackers can compile source code after delivering it to a victim (**MITRE ATT&CK T1027.004**). This broad learning rule alerts whenever `csc.exe` starts; legitimate development tools may trigger it too.

Paste these into the **separate** Detect and Respond fields:

```yaml
# DETECT
event: NEW_PROCESS
op: ends with
path: event/FILE_PATH
value: csc.exe
```

```yaml
# RESPOND
- action: report
  name: Custom - Csc.exe Execution
```

Name the rule and click **Create**.

<img width="1201" height="900" alt="image" src="https://github.com/user-attachments/assets/2e033afc-d988-413f-ba3c-cfaca1a2d9cc" />

### **RULE B — PowerShell Defender Disable Attempt**

Attackers may try to disable Microsoft Defender (**T1562.001**). This example looks for suspicious **command-line text**; it does not confirm that Defender was actually disabled.

To add the new rule, click on **D&R RULES**, then **ADD RULE**:

<img width="1230" height="409" alt="image" src="https://github.com/user-attachments/assets/c0e0ced2-7028-47b3-9169-baf93ecdc309" />

Now create the rule. You can name it *"PowershellDefenderDisable"*: 

```yaml
# DETECT
event: NEW_PROCESS
op: and
rules:
  - op: contains
    path: event/COMMAND_LINE
    value: Set-MpPreference
    case sensitive: false
  - op: contains
    path: event/COMMAND_LINE
    value: DisableRealtimeMonitoring
    case sensitive: false
  - op: contains
    path: event/COMMAND_LINE
    value: 'true'
    case sensitive: false
```

```yaml
# RESPOND
- action: report
  name: Custom - Defender Disable Attempt
```

<img width="1204" height="896" alt="image" src="https://github.com/user-attachments/assets/22d5f2bb-e7ba-4116-ba85-3f16b57dc430" />

Both custom rules should now appear in your D&R rules list:

<img width="735" height="499" alt="image" src="https://github.com/user-attachments/assets/43761046-9682-4e47-9684-6a03bbd61bac" />

---

### **Step 3: Run Controlled Tests**

Open the *15 Hidden* menu and go to **Extensions**. Select *"atomic red-team"*:

<img width="1860" height="779" alt="image" src="https://github.com/user-attachments/assets/7600a49c-e342-4307-81ae-f86b3567c777" />

Select your **Windows lab sensor**:

<img width="1436" height="694" alt="image" src="https://github.com/user-attachments/assets/65be4459-a0c6-4476-b474-0676678ca77a" />

Click **Prepare Host** and check that preparation succeeds. On Windows, this may install dependencies and add a temporary Defender exclusion for `C:\AtomicRedTeam`.

<img width="1018" height="361" alt="image" src="https://github.com/user-attachments/assets/d5d76361-2894-4320-aab6-9f2b584304c7" />

Under **Run Tests**, keep only the **stealth** category expanded using the arrow on the right:

<img width="1395" height="675" alt="image" src="https://github.com/user-attachments/assets/ecfdd703-1857-4197-9ca8-40eb7906ce4f" />

<img width="1562" height="889" alt="image" src="https://github.com/user-attachments/assets/09fbb97d-18f9-4564-8f18-c37cf43831aa" />

**Do not select the entire category.** Select only these two techniques:

- **T1027.004 — Compile After Delivery:** includes execution of `csc.exe`, which can trigger **Rule A**.
- **T1036.007 — Double File Extension:** simulates file-name masquerading and may trigger relevant **Sigma** detections.

<img width="567" height="520" alt="image" src="https://github.com/user-attachments/assets/901c0b9f-fdcd-44d4-8ab8-a00ea2cf4f2f" />

> [!NOTE]
> LimaCharlie selects ATT&CK **techniques**, not individual atomic tests. Each technique may run more than one test. Sigma alerts depend on which managed rules are installed and which events are collected.

Choose your **Windows lab sensor** under **SID**, enable **CLEAN** at the bottom of the page, then click **RUN TESTS**:

<img width="1523" height="866" alt="image" src="https://github.com/user-attachments/assets/1b8e711f-e42f-4f80-b0d3-08f7c28faa7d" />

A **Request Success** message and a **Job ID** confirm that LimaCharlie accepted the request, **not** that every test finished successfully:

<img width="1124" height="392" alt="image" src="https://github.com/user-attachments/assets/7e107747-a82d-4b5d-a6fb-5173742a8aff" />


---

### **Step 4: Investigate Detections and Test the Second Rule**

Return to your organization's **Detections** page. Look for alerts generated by **Sigma** and **Custom - Csc.exe Execution** from Rule A. The exact number and timing of detections can vary.

> [!TIP]
> **Check the DATE filter at the top of Detections.** It can affect which alerts are displayed. If you cannot find a recent detection, adjust the date/time to include when you prepared the host or ran the tests, and check the **RANGE** setting. Do not assume a missing alert means the rule failed.

<img width="1756" height="613" alt="image" src="https://github.com/user-attachments/assets/0a587ed4-305b-4131-86bf-1ec449ef9647" />

<img width="1608" height="569" alt="image" src="https://github.com/user-attachments/assets/8107ef92-6413-459c-b198-2a09a5972c67" />

**Double-click** the **Custom - Csc.exe Execution** alert to open its details:

<img width="1572" height="874" alt="image" src="https://github.com/user-attachments/assets/003b1d7b-e485-4b28-8663-8553f7ef4862" />

Explore the three tabs at the top of the panel:

**1. DETECTION — What triggered the alert?**

The event is shown as structured **JSON**. Expand `detection -> detect -> event` and identify:

- **FILE_PATH:** the executable detected (`csc.exe`). Our custom rule matches this field.
- **COMMAND_LINE:** how `csc.exe` was launched, including any command-line arguments.
- **PARENT:** the process that launched it. In our example, `powershell.exe` is the parent and its command line contains `-EncodedCommand`.
- **TIME:** when the detection was generated, shown at the top of the panel.

<img width="769" height="728" alt="image" src="https://github.com/user-attachments/assets/2ea3421f-c740-45f7-a0cb-7108bc2c9c17" />

**2. ROUTING — Where did the event come from?**

This tab shows metadata such as the sensor ID (`sid`), hostname, event type (`NEW_PROCESS`) and IP addresses. Much of this information also appears in the detection JSON:

<img width="764" height="723" alt="image" src="https://github.com/user-attachments/assets/d8a64d50-d754-4642-8b23-bfc486af54bb" />

**3. AI EXPLAIN — How could an analyst investigate it?**

Open **AI EXPLAIN**. The explanation may take a few minutes to appear. Read the **Alert Description** and **Investigation Recommendations** to see how LimaCharlie interprets the process activity and suggests next steps.

<img width="769" height="725" alt="image" src="https://github.com/user-attachments/assets/b85c58eb-961a-4992-a471-320afc65ddca" />

<img width="764" height="727" alt="image" src="https://github.com/user-attachments/assets/786385ec-57a8-4ee4-8e61-2e4292b5bc54" />

> [!IMPORTANT]
> **AI EXPLAIN is an assistant, not evidence.** Its description and recommendations may contain assumptions or mistakes. Verify any claims against the actual event fields before concluding that an attack occurred.

**Why did our custom rule fire?** A `NEW_PROCESS` event had a `FILE_PATH` ending in `csc.exe`, so the rule's `report` action created the detection. This alone does **not** prove malicious activity.

> [!NOTE]
> The example `csc.exe` alert was recorded during **Prepare Host**, before the later Run Tests request. Compare timestamps before attributing a detection to a specific test.

If you want to examine the underlying event, use **VIEW TIMELINE** to open the sensor's Timeline / Live Feed and compare the process information:

<img width="755" height="234" alt="image" src="https://github.com/user-attachments/assets/47a48c6a-aebb-4a78-a86b-e1d845f8774d" />

<img width="1554" height="868" alt="image" src="https://github.com/user-attachments/assets/5cff2d41-227d-4408-836f-b912e08ab77d" />

If the custom alert is missing, check that **Rule A** is enabled and whether `csc.exe` actually ran. A **Job ID** only confirms that a test request was accepted; check `test_result` / `run_success` / `run_failed` and sensor `RECEIPT` events if needed.

#### **Trigger Rule B Manually**

Now let's test **PowershellDefenderDisable**. On the **Windows lab VM**, open **PowerShell** and run:

```powershell
powershell.exe -NoProfile -Command "Write-Output 'Set-MpPreference -DisableRealtimeMonitoring true'"
```

> [!IMPORTANT]
> This command **only prints text**. It does **not** disable Windows Defender. Our rule matches the three suspicious strings in the **process command line**, so it can also flag harmless activity.

<img width="1070" height="152" alt="image" src="https://github.com/user-attachments/assets/a03ea525-2320-44bb-aed7-ead24beb648d" />

Return to **LimaCharlie -> Detections**. **Check the DATE field again:** set it to a time shortly before you ran the PowerShell command (for example, `18:00` if you executed it at `18:26`) so the relevant detections appear. Verify **RANGE** if necessary.

Look for **Custom - Defender Disable Attempt**. You may also see **Non Interactive PowerShell Process Spawned**, generated by a managed Sigma rule. Double-click the custom alert and inspect `COMMAND_LINE` to find the three strings that matched Rule B.

<img width="1578" height="874" alt="image" src="https://github.com/user-attachments/assets/7281a1f1-ee23-4d97-8ee4-f5cd3104b454" />

**Think about it:** Which alerts came from Sigma, and which from our custom rules? Does an alert prove an attack succeeded? **Why or why not?**

---

### **Step 5: Clean Up the Lab VM**

Return to **Atomic Red Team -> Cleanup Host** and run cleanup for the same Windows sensor. Check the result; **CLEAN** during Run Tests does not replace host cleanup.

<img width="1850" height="636" alt="image" src="https://github.com/user-attachments/assets/6738104e-042e-4975-9ba2-044aa30f385c" />


---

### **Conclusion**

You installed Atomic Red Team and Sigma, created two custom D&R rules, ran two controlled ATT&CK techniques, and investigated **Sigma** and **custom detections**. You also triggered a detection manually without actually disabling Defender.

Remember: **a telemetry event is not automatically an alert, and an alert is not proof of compromise.** Context matters.

**References:** [LimaCharlie Atomic Red Team](https://docs.limacharlie.io/5-integrations/extensions/third-party/atomic-red-team/) · [LimaCharlie D&R operators](https://docs.limacharlie.io/8-reference/detection-logic-operators/) · [Atomic Red Team T1027.004](https://www.atomicredteam.io/docs/atomics/T1027.004)

---

[Back to the Section](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/toolsAndPlatforms.md)
