![image](/FilesForLabs/images/blueantisyphon.png)

# **LimaCharlie Lab**

---

## **Part 1 of 2 – Endpoint Monitoring & Threat Detection**

In this lab we will be using **LimaCharlie** to investigate **endpoint monitoring** and **threat detection**.

### **What is LimaCharlie?**

LimaCharlie is a lightweight browser-based tool. It helps monitor systems, detect threats, and respond quickly to suspicious activity. This walkthrough uses the **Chrome** browser, but any browser may be used.

---

## **Step 1: Access LimaCharlie and sign up**

Open a browser and go to:

```
https://app.limacharlie.io/
```

Click **"Sign up"**:

<img width="526" height="465" alt="image" src="https://github.com/user-attachments/assets/d99bf419-484b-45ca-9131-03d6767381ea" />

Fill out the required field and press **"Continue"**, then press **"Add Password"**: 

<img width="523" height="644" alt="image" src="https://github.com/user-attachments/assets/3d3e3065-bda3-4654-83fe-eab661602f29" />

Fill out the required fields and click **"Sign Up"**.

<img width="517" height="704" alt="image" src="https://github.com/user-attachments/assets/e1b4c997-6dcc-4d9e-93da-dc1c116b4207" />

Check your email, click the verification link, then return to your browser and refresh the page.

---

## **Step 2: Setup Company Information**

You will be asked questions about your company. Use fictional information.

Enter the following details:

- **Are you a service provider?** -> *No*
- **What best describes your role?** -> *Security Engineer*
- **What use cases are you exploring?** -> *Endpoint Detection & Response*
- **Please describe the outcome you would like to achieve.** -> *Learn how to monitor endpoints, detect threats, and investigate security events.*
- **How did you hear about us?** -> *Black Hills Info Sec*

<img width="786" height="845" alt="image" src="https://github.com/user-attachments/assets/406e2852-2309-42b5-8d7e-2964e7b3051c" />

Check the box to agree to the Terms of Service and Privacy Policy.

Click **"Get started"** then let's set up your first **Organization**.

# An Overview of LimaCharlie.

Before you get set up, here's the basics:

* *Sensors* are the primary input for data into LimaCharlie. They run on a variety of supported platforms and send JSON events to LimaCharlie's cloud in real-time. Embedded platforms (e.g. Windows, Mac, Linux) expose deeper capabilities like sending commands and collecting artifacts.
* *Organizations* are akin to “projects” - they're located in a chosen region and are where configuration and storage is located for a fleet of Sensors and their accompanying infrastructure.
* *Outputs* allow you to forward your data to storage only you control — like an SFTP server or Amazon S3. Storage within LimaCharlie is optional and allows you to store artifacts (i.e. logs) as well as search, browse, and replay historical Sensor data.
* *Add-ons* let you enable features within organizations à la carte, allowing you to run each org as lean or as sophisticated as your needs require.

The first step is to create an organization.

In the *Endpoints* tab, fill out your fictional organization’s details.

<img width="1233" height="835" alt="image" src="https://github.com/user-attachments/assets/4bf21504-4edc-410f-87f9-a66bd2e139a6" />

Click **"Create Organization"**.

Wait for the organization to be created.

---

## **Step 3: Create & Install a Sensor**

Once you create an organization, you will be asked to select an *installation key*. An installation key can be used for multiple sensors. 
Since this is our first organization, we'll create a new key.

<img width="894" height="356" alt="image" src="https://github.com/user-attachments/assets/9d36610f-358d-48a7-ba14-714f474942db" />

Fill in a description and tags, then click **"Create"**. For the tag, type **demo**, then create the tag. **"Use Public CA"** is not necessary. 

<img width="806" height="448" alt="image" src="https://github.com/user-attachments/assets/eb97ebd6-a1a8-486b-95e1-ea65a956b29a" />

Select *Windows* in the *Install a sensor* section. Open up *Powershell* and run the command to install the sensor. 

<img width="1450" height="660" alt="image" src="https://github.com/user-attachments/assets/aaaf689a-96f5-4fac-a074-39a99b9cc75d" />

<img width="370" height="283" alt="image" src="https://github.com/user-attachments/assets/0b7050ae-f960-4460-aee6-1c2f2a2c230b" />

<img width="798" height="327" alt="image" src="https://github.com/user-attachments/assets/918ea22b-840a-461b-8b4c-6e68e6d0a916" />

Paste the copied command string and press **Enter**.

If successful, your output will look like this:

![](attachments/correctoutput.png)

Return to your browser. You should see a confirmation message. Click on **"DONE"**.

<img width="899" height="725" alt="image" src="https://github.com/user-attachments/assets/0067705f-b3f0-4b21-9138-4ce6dab0adaf" />

>[!TIP]
>
> **Note**: Your computer name will differ.

You will automatically be taken to the **Sensors List**. 
If you already have a Lima Charlie account, you can add new sensors from here : 

<img width="1667" height="800" alt="image" src="https://github.com/user-attachments/assets/27d87168-a6a3-47bf-bd48-c1d203a25952" />

If you want to create new sensors, click **ADD SENSOR** and select the sensor type (in this case, *"Windows"*). The process is the same. 

<img width="974" height="410" alt="image" src="https://github.com/user-attachments/assets/277ed42a-cffa-4b48-8ae7-d8a261509cd5" />

---

## **Next Steps**

- [Continue to Part 2 of the Lab](./lima_charlie_lab_part2.md)


>[!IMPORTANT]
>
> **Important**: Always destroy your lab environment after completing exercises.

---
[Back to the Section](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/toolsAndPlatforms.md)
