![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Honey User 

# Windows VM

In this lab we will be setting up a poor persons SIEM with an "alert" generated whenever the **Honey Account Frank** is accessed. 

Why Frank? 

**Because.**

Let's get started!

- First, we will need to create the users and the Frank account. 

- Let's open a command prompt:

<img width="74" height="91" alt="image" src="https://github.com/user-attachments/assets/5b960092-421b-4d78-bce6-a504cf4a0559" />


- Now, we will need to navigate to the C:\Tool directory and add the example users and Frank. 

```bash
cd \IntroLabs
```

```bash
200-user-gen.bat  
```

- It should look like this: 

<img width="385" height="482" alt="2026-03-26_09-21" src="https://github.com/user-attachments/assets/61c73044-6992-4bf9-b5af-2fe3ca08bab2" />

- Now, we need to create the Custom View in **event viewer** to capture anytime someone logs in as Frank. 

- To do this click the Windows Start button then type Event Viewer. 

- It should look like this: 

<img width="618" height="583" alt="event_viewer" src="https://github.com/user-attachments/assets/a21fca78-95fb-4598-91ac-357ffbbdf0ba" />

- When in the **Event Viewer**, select `Windows Logs` > `Security` then `Create Custom View` on the far-right hand side. 

- It should look like this: 

![](attachment/Clipboard_2021-03-12-11-18-15.png) 

- When `Create Custom View` opens, please select **XML**: 

![](attachment/Clipboard_2021-03-12-11-19-02.png) 

- Then, select Edit query Manually, Press **Yes** on the **Alert Box** and then replace the text in the query with the text below: 

~~~~~~ 
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">* [EventData[Data[@Name='TargetUserName']='Frank']]</Select>
  </Query>
</QueryList>

~~~~~~

- It should look like this: 

![](attachment/Clipboard_2021-03-12-11-21-57.png) 

- Now, press **OK**. 

- When the Save Filter to Custom View box opens, name the filter Frank then press **OK**.

- When we click on our **new View** we will see the Events associated with the **Frank Account** Being Created: 

![](attachment/Clipboard_2021-03-12-11-24-20.png) 

- Now, let's trip a few more. 

- Back at your Windows Command Prompt 

```bash
cd \IntroLabs
```

```bash
powershell
```

```bash
Set-ExecutionPolicy Unrestricted
```

```bash
Import-Module .\LocalPasswordSpray.ps1
```

- It should look like this: 

<img width="815" height="179" alt="2026-03-26_09-22" src="https://github.com/user-attachments/assets/6cf93e86-6168-4c76-9512-c8f69352104f" />

- Now, let’s try some **password spraying** against the local system! 

```bash
Invoke-LocalPasswordSpray -Password Winter2025
```

- It should look like this: 

<img width="598" height="256" alt="2026-02-23_14-55" src="https://github.com/user-attachments/assets/0e299d08-daa9-498a-bb1b-2b95dd8d5c1e" />

- Now we need to clean up and make sure the system is ready for the rest of the labs: 

PS C:\Tools> `exit` 

C:\Tools> `user-remove.bat` 

<img width="365" height="285" alt="2026-02-23_15-02_1" src="https://github.com/user-attachments/assets/c82559fb-6c47-4c76-a306-498c572da9fb" />

- Now, let's see if any **alerts** were generated. 

- Go back to your **Event Viewer** and refresh (`Action` -> `Refresh`). 

- You should see the **"Alerts"**! 

![](attachment/Clipboard_2021-03-12-11-32-18.png) 

- Just for a bit of reference.  We did this locally as an example of setting this up on a full SIEM.  We did it in less than 20 min.  Your SIEM team working with your AD Ops team should be able to pull this off. 

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/pcap/AdvancedC2PCAPAnalysis.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/honeyshare/HoneyShare.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---

  

 

 





