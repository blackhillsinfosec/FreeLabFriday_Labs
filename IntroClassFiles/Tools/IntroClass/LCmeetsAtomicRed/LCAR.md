For **Part 1**, click [here](/IntroClassFiles/Tools/IntroClass/limacharlie/limacharlie.md). Please complete Part 1 before starting this lab.

<hr>

## Lab Objective

In this lab we will:

- Install the **Atomic Red Team** extension in LimaCharlie
- Run a controlled and **fake** cyber attack against our Windows machine
- Use LimaCharlie to see what gets logged and detected
- Understand how a real-world attack may set off bells and whistles for an analyst to investigate

---

> [!NOTE]
> We will pick up where we left off in Part 1, in the browser, logged into the LimaCharlie web interface.

---

## Step 1: Install the Atomic Red Team Extension

We need to install the Atomic Red Team plugin that LimaCharlie offers.

Start by navigating to the **"Add-ons"** tab in the top right of the web page.

<img width="1335" height="638" alt="image" src="https://github.com/user-attachments/assets/805983d6-dd84-44ea-ae2c-fc69f8823cf5" />


Scroll down until you see the Atomic Red plugin. Click the **"ext-atomic-red-team"** plugin.

<img width="937" height="881" alt="image" src="https://github.com/user-attachments/assets/3647d70a-94a8-4da3-ac46-85a194309a37" />

> [!TIP]
> Take a minute to look at the different plugins and see the full capabilities and features LimaCharlie has to offer.

Locate the subscribe button on the right side of the page, and click **"Subscribe"**.

<img width="916" height="363" alt="image" src="https://github.com/user-attachments/assets/1fad7cd0-0ca4-42d2-880e-04db72873378" />



---

## Step 2: Select Your Device

After Atomic Red finishes installing, return to your organization and click on your machine.

<img width="917" height="353" alt="image" src="https://github.com/user-attachments/assets/f433792f-e5c5-4240-b605-cb541e67407c" />


On the left side of your screen, click on **"Extensions"** to expand the drop-down menu. Select **"Atomic Red Team"**.

<img width="1170" height="407" alt="image" src="https://github.com/user-attachments/assets/d78a0902-2d3a-4346-aad6-0c22eee6a304" />


On the next screen, click the drop-down next to the side bar at the top. Then, select **your** device and hit **Prepare Host**.

<img width="1055" height="377" alt="image" src="https://github.com/user-attachments/assets/bfc511ca-2f20-4708-b3f3-be38a20cf3fe" />



---

## Step 3: Run the Atomic Red Team Tests

Scroll down until you find the **command-and-control** category. Select the box next to the category header and make sure that it selects all of the boxes below.

<img width="1029" height="358" alt="image" src="https://github.com/user-attachments/assets/e1c6f50e-20c3-49a8-9664-7851596904ad" />


Now, hit **Run Tests**.

<img width="1029" height="358" alt="image" src="https://github.com/user-attachments/assets/49bc3def-e64a-4173-a2ed-d62451247222" />

---

## Step 4: Review the Detections

Move over to the **"Detections"** tab on the left and start going through the event logs.

<img width="750" alt="Detections tab" src="attachments/detections.png" />

<img width="750" alt="Logs screen" src="attachments/logsscreen.png" />

There will be a lot of events. Every single time the page is refreshed, more attacks will appear.

Look through all of the logs and note the **cmd.exe** or **powershell** invokes that are taking place. These are **(usually)** indications that something malicious is occurring and needs to be examined further.

<img width="750" alt="Detected" src="attachments/DETECTED.PNG" />

> [!TIP]
> LimaCharlie is an amazing tool because of its versatility. It has an easy-to-use interface and allows a user to dig deeper to see what's happening before, during, and after an attack. It works at both small and large scale, and its many plugins help automate difficult tasks.

<hr>

**Continuing on to the next Lab?** [Click here to get back to the Navigation Menu](/IntroClassFiles/navigation.md)

**Finished with the Labs?** Please be sure to destroy the lab environment! [Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)
