![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **SOC Core Skills** Course:

https://www.antisyphontraining.com/product/soc-core-skills-with-john-strand/

---

# Velociraptor 

In this lab we will be installing and using **Velociraptor** to look at the various IR artifacts on your computer.

Check out their website here:

<pre>https://www.velocidex.com/</pre>

Velociraptor is a free **EDR** that can help us better understand of the inner workings of a computer.

Furthermore, it is an excellent example of commercial tools you will encounter in your security career.

They also have offer training on their tool if you want to dig deeper.

<pre>https://www.velocidex.com/training/</pre>

Let's get started.

Open a **Windows command prompt**.

<img width="294" height="296" alt="2026-02-07_17-05" src="https://github.com/user-attachments/assets/8957ed22-91e0-4e05-903f-e93aefd6cb19" />


When the terminal opens, navigate to the appropriate directory by using the following command:

```bash
cd \IntroLabs
```

For this installation, we are going to set up **Velociraptor** as a standalone deployment.  This means the server and the client will be run on the same system.

Within the command prompt, run the following command:

```bash
velociraptor-v0.75.6-windows-amd64.exe config generate -i
```

When it asks about the **Deployment Type**, choose **Self Signed SSL**

<img width="610" height="111" alt="2026-03-15_11-02" src="https://github.com/user-attachments/assets/e34c0e98-6fec-4b14-9d29-2a1abd949cd2" />

When it asks about the **OS**, please choose **Windows**.

<img width="557" height="120" alt="2026-03-15_11-04" src="https://github.com/user-attachments/assets/567ec56e-7ed2-403d-9d2c-10babf2d2661" />

When it asks about the **Path to the datastore**, **just hit enter**.  This will keep the default.

<img width="906" height="111" alt="2026-03-15_11-06" src="https://github.com/user-attachments/assets/c5a2adcf-6a82-43aa-a593-1826c4f536e4" />

When it asks about the path to the **logs directory**, **just hit enter** to accept the default.

<img width="643" height="94" alt="2026-03-15_11-09" src="https://github.com/user-attachments/assets/2189706f-bc81-4734-afdf-f468a488964a" />

When it asks about the **PKI Certificate Expiration**, **just hit enter** to accept the default.

<img width="606" height="171" alt="2026-03-15_11-10" src="https://github.com/user-attachments/assets/8acc7f0f-eb75-4c0e-b8f8-cd2b53d6d384" />

When it asks about the **Registry for Client Writeback**, **just hit enter** to accept the default.

<img width="803" height="164" alt="2026-03-15_11-10" src="https://github.com/user-attachments/assets/930e3b8b-986c-42d1-8741-cc4d015169a7" />

When it asks about the **DNS name**, **just hit enter**.  It will set the default to localhost.  This will work fine as we are just running this locally.

<img width="581" height="77" alt="2026-03-15_11-14" src="https://github.com/user-attachments/assets/6a718c5c-e7a6-49b8-a42f-1c0162939c21" />

When asked about which **DNS Type** is used, select **None** and press enter.

<img width="827" height="113" alt="2026-03-15_11-14" src="https://github.com/user-attachments/assets/12fa7d6c-4bfb-4f6f-ad32-eb9bd035a387" />

If prompted about using **Experimental Websocket**, enter **"No"**

<img width="729" height="153" alt="2026-03-15_11-17" src="https://github.com/user-attachments/assets/db146be1-8ec6-4c29-bf86-ac1591dd12b3" />

For the **default ports**, once again, **just hit enter** twice to accept 8000 and 8889 as the defaults.

<img width="399" height="114" alt="2026-03-15_11-19" src="https://github.com/user-attachments/assets/fc2b01b0-e371-4866-b672-8dcc193b6bd8" />

When it asks about the **Username and Password**, **just hit enter** twice to leave them empty.

<img width="435" height="143" alt="2026-03-15_11-19" src="https://github.com/user-attachments/assets/d01aaf37-bd18-4e19-b5b5-e6983fb741eb" />

When it asks about the **Name of file** of the config file, **just hit enter** to accept the default.

<img width="325" height="75" alt="2026-03-15_11-24" src="https://github.com/user-attachments/assets/b4bfd136-550c-4e14-9275-d227566984d0" />

Let’s add a **GUI** user.

```bash
velociraptor-v0.75.6-windows-amd64.exe --config server.config.yaml user add root --role administrator
```

When it asks for the password, please choose a password you will remember.

When finished, it should look similar to 

<img width="1063" height="239" alt="2026-03-15_11-24" src="https://github.com/user-attachments/assets/76c803ea-dc16-4f10-8184-385d1f121968" />

Lets run the **msi** to load the proper files to the proper directories:

```bash
velociraptor-v0.75.6-windows-amd64.msi
```

Time to start the server.

```bash
velociraptor-v0.75.6-windows-amd64.exe --config server.config.yaml frontend -v
```

This will take some time, be patient.

There will be some red text.  **Don’t panic.**

Surf to the **GUI** and see if it worked!

<pre>https://127.0.0.1:8889</pre>

When you load the page, there will be an **SSL error** about the self-signed cert.  That is fine.

![](attachment/velociraptor_warning.png)

Select Advanced then proceed to **127.0.0.1**

![](attachment/velociraptor_continue.png)

When it asks for the Username and Password, please enter root and the password you chose earlier.

Please select **Inspect** the server's state.

![](attachment/velociraptor_login.png)

Once logged in, you will see the following:

![](attachment/velociraptor_velociraptorhome.png)

Next, we need to start the client. Lucky for us, it is the same executable.

We will need to open another **Windows Command Prompt**. Right click on the terminal icon in the task bar, and select **"command prompt"**:

<img width="294" height="296" alt="2026-02-07_17-05" src="https://github.com/user-attachments/assets/8957ed22-91e0-4e05-903f-e93aefd6cb19" />

Then Navigate to the **IntroLabs** directory.

```bash
cd \IntroLabs
```

We will need to start the client.  To do this will need to run the **MSI** first.

```bash
velociraptor-v0.75.6-windows-amd64.msi
```

When you get the pop up, select Run.  This will install the proper libraries and files.

Next, we will start the client.

```bash
velociraptor-v0.75.6-windows-amd64.exe --config server.config.yaml client -v
```

It will look something like this:

![](attachment/velociraptor_clientstart.png)

Now, let’s go back to the Velociraptor GUI and select the Home button in the upper left.

![](attachment/velociraptor_velociraptorGUIhome.png)

You should see **one** connected client.

<img width="910" height="664" alt="2026-03-15_11-56" src="https://github.com/user-attachments/assets/e86d04c8-64a1-4ff4-9380-33e5f79ade88" />

Now let’s look at what we can do with this.

This is **not** necessarily a detection platform.  It is designed to allow you to dig when you get an **alert** on malware signatures or from suspicious traffic. 

Understand, it is not a replacement for **AV!**

Let’s **"Show All"** Clients. Go to the search bar at the top of the screen, hit the dropdown.  

![](attachment/velociraptor_showall.png)

As you can see below there will only be one client.

![](attachment/velociraptor_onlyclient.png)

If you select that client, you can get additional information about that system.

![](attachment/velociraptor_additionalinfo.png)

Now, on the top right of the window, select **Shell**.

![](attachment/velociraptor_selectshell.png)

This allows us to run commands on the target system.  Think of the commands that we ran from the **Windows CLI**, we can run those here too.

Please click on the **PowerShell** box and select **Cmd**.

![](attachment/velociraptor_powershelldropdown.png)

Now, enter `netstat -naob` in the cmd box and select **"Launch"**.


This will not display the results right away. To see the results, select the **"Eye"** icon:

![](attachment/velociraptor_eye.png)

Now you can see the results, click **Active Connections**:

<img width="453" height="259" alt="2026-03-15_11-56" src="https://github.com/user-attachments/assets/8f3e9ae5-9eb5-491a-aa8b-435692cde8e8" />

Now click the **Text** tab

<img width="862" height="802" alt="2026-03-15_12-03" src="https://github.com/user-attachments/assets/4d9f5fb0-1aa6-4ab0-89b9-c1669ab93af4" />

Let’s do a Hunt.   Please select the Hunt icon.

![](attachment/velociraptor_selecthunt.png)

To start a Hunt, please select the **"+"** icon.

![](attachment/velociraptor_newhunt.png)

Name your Hunt, then select **"Select Artifacts"** on the bottom.

![](attachment/velociraptor_selectartifacts.png)

Within the window, scroll down to find **"Generic.System.Pstree"** and select it.

![](attachment/velociraptor_genericpstree.png)

Review on the bottom.

![](attachment/velociraptor_reviewtab.png)

We now have an overview of what is going to be run on all systems.  Which in our case, is only one system.

Now select Launch.

It will start the Hunt and load it in the **queue**.

![](attachment/velociraptor_startedhunt.png)

Please select our Hunt.  Now, we can run it.  Press the **Play** button above.

![](attachment/velociraptor_play.png)

When you get the pop-up, select **Run them all!**

>[!NOTE]
>
>This will take a few moments.

When done, you will see **"Total scheduled is 1"** and **"Finished Clients is 1"**.

You can also download the results.

Please select **Download Results.**

![](attachment/velociraptor_download.png)

Then, **Summary (CSV Only)**.

![](attachment/velociraptor_csvonly.png)

This will create a zip with the output.

Please download that by clicking on the **zip file**.

![](attachment/velociraptor_downloadzip.png)

Go ahead and open the **zip file**, navigate into the results folder.

![](attachment/velociraptor_opencsv.png)

Then, open the csv file with **NotePad**.

![](attachment/velociraptor_wordpad.png)

Granted, this is not optimal.  We did not load **Excel** on this system because of licensing restrictions.  However, you can copy this over to your host system and open it there. 

However, of you want to see a simple HTML report you can click on the turn back time icon on the left side (Right above the binoculars) and then clock Download Results > Prepare Collection Report, then click on the HTML report that appears below it.

We have not even begun to touch what we can do with this awesome tool.

Want to try something cool?  Run a **Meterpreter agent** on you Windows system.  Then, go through **Velociraptor** to create a Hunt to find it.  There are many Windows artifacts you can pull.  You do not need to just run one at a time.  You can run multiple.

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/FirewallLog/FirewallLog.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/DomainLogReview/DomainLogReview.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---




