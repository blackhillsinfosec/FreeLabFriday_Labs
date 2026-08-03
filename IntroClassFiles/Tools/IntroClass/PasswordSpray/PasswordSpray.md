![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Password Spray

<hr>

## Step 1: Disabling Defender
First things first, disable **Defender**. Open an instance of **Windows PowerShell** by clicking on the icon in the **desktop**. Then run the following:

<img width="74" height="91" alt="image" src="https://github.com/user-attachments/assets/5676575e-6ba5-4971-b1de-68d60234af47" />


```ps
Set-MpPreference -DisableRealtimeMonitoring $true
```

This will disable **Defender** for this session.

If you get angry red errors, that is Ok, it means **Defender** is not running.
<hr>

## Step 2: Run The Batch File
Let's get started by opening a **Command Prompt** terminal by clicking on the icon in the **desktop**.

<img width="74" height="91" alt="image" src="https://github.com/user-attachments/assets/d7242bdb-1c7d-47fc-a214-26ab3d46af64" />

Once the terminal opens, navigate into the appropriate directory by running the following command:

```bash
cd \IntroLabs
```

We need to run the batch file named **200-user-gen** 

Do so by typing the name of the batch file and hitting enter:

```bash
200-user-gen.bat
```

It should look like this:

<img width="385" height="482" alt="2026-03-26_09-21" src="https://github.com/user-attachments/assets/61c73044-6992-4bf9-b5af-2fe3ca08bab2" />

Let this run all the way through. 

**Even though it looks endless, it's not!**
<hr>

## Step 3: Running LocalPasswordSpray
We will need to start **PowerShell** to run **"LocalPasswordSpray"**

Launch it by typing the following and hitting enter:

```bash
powershell
```

Run the following two commands:

```ps
Set-ExecutionPolicy Unrestricted
```

```ps
Import-Module .\LocalPasswordSpray.ps1
```

It should look like this:

<img width="815" height="179" alt="2026-03-26_09-22" src="https://github.com/user-attachments/assets/6cf93e86-6168-4c76-9512-c8f69352104f" />
<hr>

## Step 4: Password Spraying The Local System
Let’s try some password spraying against the local system!

```ps
Invoke-LocalPasswordSpray -Password Winter2025
```

It should look like this:

<img width="598" height="256" alt="2026-02-23_14-55" src="https://github.com/user-attachments/assets/0e299d08-daa9-498a-bb1b-2b95dd8d5c1e" />
<hr>

## Step 5: Cleaning Up
We need to clean up and make sure the system is ready for the rest of the labs.

Run the following two commands:

```ps
exit
```

```bash
user-remove.bat
```

<img width="365" height="285" alt="2026-02-23_15-02_1" src="https://github.com/user-attachments/assets/c82559fb-6c47-4c76-a306-498c572da9fb" />

Let this run all the way through. 

**Even though it looks endless, it's not!**