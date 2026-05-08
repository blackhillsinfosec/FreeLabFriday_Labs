![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)
# ScoutSuite 
----- 
# For the Ubuntu VM

## The objective of this lab is to use Scout Suite to audit an AWS cloud environment and identify critical security misconfigurations related to Identity Access Management (IAM), Cloud Storage (S3), and Virtual Machines (EC2).

If you want to learn a bit about this tool check the [Scout Suite Documentation](https://www.google.com/search?q=/courseFiles/tools/ScoutSuite.md)

### Phase 1: Account Creation 

- Go to the [AWS Free Tier web page](https://aws.amazon.com/free/) and click on **"Create a Free Account"**.
  
<img width="1417" height="479" alt="image" src="https://github.com/user-attachments/assets/c5b52069-a4b6-48d1-87c1-377b4fb7a2bc" />

- Fill the email and account name fields:
  
<img width="856" height="784" alt="image" src="https://github.com/user-attachments/assets/3dc88976-f9aa-41b4-84aa-de44eb76c893" />

- After validating your email you will be asked to set the root password. Fill the two fields:
  
<img width="757" height="674" alt="image" src="https://github.com/user-attachments/assets/03a40be9-5e6e-4a88-9727-1348f6da57f3" />

- To demonstrate ScoutSuite usage the Paid plan is not required. Choose the **Free Plan**:

<img width="870" height="661" alt="image" src="https://github.com/user-attachments/assets/7e11a906-1f39-4a8c-84c1-f3d9d245aea4" />

>[!IMPORTANT]
> Amazon requires a valid physical address, a phone number for identity verification and a valid credit/debit card. This is a mandatory step for all cloud providers.
> <br></br>**What to do:** Fill in your contact information. Since this is a personal **"Free Tier"** account, your billing address should match the one associated with your credit/debit card. 

<img width="647" height="788" alt="image" src="https://github.com/user-attachments/assets/d329d720-1cce-4917-b914-374861da8906" />

- Fill the Billing information. Amazon will only hold **$1** for 3-5 days to verify your account.
  
<img width="727" height="951" alt="image" src="https://github.com/user-attachments/assets/aa27be6f-680e-4480-b187-28d962c66f64" />


- Verify your phone number: 

<img width="625" height="424" alt="image" src="https://github.com/user-attachments/assets/d9a41ce2-ddae-4a7b-8946-0ceb9c8d0898" />

- You should now have access to the **Amazon Web Services**. This will grant you : 
  - $100 in credits 
  - access to 30+ AWS services
    
>[!TIP] 
> Scout Suite is designed to perform security audits on AWS. It leverages APIs to scan for misconfigurations - such as open security groups, unencrypted S3 buckets and overly permissive IAM roles.

-----
### Phase 2: Creating the Target Environment (Automated via CloudFormation)

Before we start the audit, we need a "broken" environment. Instead of manual setup, we use *Infrastructure as Code (IaC)* to deploy our targets:

  * *EC2 (Elastic Compute Cloud):* Virtual servers in the cloud. We make it vulnerable by opening *Port 22 (SSH)* to the entire internet ($0.0.0.0/0$), allowing anyone to attempt a brute-force attack.
  * *S3 (Simple Storage Service):* Cloud object storage. We make it vulnerable by *disabling public access blocks*, effectively making our "private" files accessible via a simple URL.
  * *IAM (Identity and Access Management):* Controls who can do what. We create a user with *high privileges* but *no Multi-Factor Authentication (MFA)*, a major security red flag.
  * *AWS CloudFormation:* An AWS service that allows us to deploy resources using a single script. We use it here for *speed, consistency, and easy cleanup* after the lab.

-----

#### 1\. Deploy the Vulnerable Stack

  - Download or create a file named lab.yaml with the script provided ![here]().
  - Navigate to *CloudFormation* in the AWS Console:
    <img width="1615" height="891" alt="image" src="https://github.com/user-attachments/assets/36197982-992f-4fe6-bfeb-7503213a6b9a" />
  - Click *Create stack* -\> *With new resources (standard)*.
    <img width="1787" height="427" alt="image" src="https://github.com/user-attachments/assets/173e5f3b-53e1-45af-aab8-415d8af85a54" />
  - Select *Upload a template file, choose your lab.yaml, and click **Next**.
    <img width="1777" height="768" alt="image" src="https://github.com/user-attachments/assets/c0f83a6b-b9b6-4080-bc6b-b3824e32e594" />
  - Give the stack a name (e.g., ScoutSuite-Lab) and keep clicking *Next* until you hit *Submit*:
    <img width="1775" height="645" alt="image" src="https://github.com/user-attachments/assets/eb975d21-104e-4a9a-8063-306e8a551ac7" />
  - In the **"Stack Failure options"** section, leave **"Roll back all stack resources"** selected:
    <img width="1684" height="830" alt="image" src="https://github.com/user-attachments/assets/6522a40b-6c6b-459e-9141-d562f19320f1" />
  - Scroll down to select *I acknowledge that AWS CloudFormation might create IAM resources with custom names: 
    <img width="1366" height="748" alt="image" src="https://github.com/user-attachments/assets/f0b2f535-18a5-4592-a7aa-41060ca6dbe5" />
  - Scroll down and click **Submit**:
    <img width="1361" height="885" alt="image" src="https://github.com/user-attachments/assets/f9616562-51ea-4254-b57d-898713065aea" />
  - Wait until the status shows **"CREATE\_COMPLETE"**:
    <img width="1787" height="846" alt="image" src="https://github.com/user-attachments/assets/f81732fa-21b9-45f6-a2c6-eb99ddbc6468" />


#### 2\. Generate Audit Keys (The Manual Step)

CloudFormation creates the user, but for security reasons, it won't generate the secret keys for you. You must do this manually:

  - Click on the **"resources"** tab and then on the **Scout Auditor Physical ID**:
    <img width="1540" height="749" alt="image" src="https://github.com/user-attachments/assets/d93fde73-2b77-40a5-87da-7768ec6fc980" />
  - You are now in the IAM console. Go to the *Security credentials* tab:
    <img width="1505" height="562" alt="image" src="https://github.com/user-attachments/assets/06710257-e697-420e-861f-4645417f8ac1" />
  - Scroll down to *Access keys* and click *Create access key*:
    <img width="1600" height="409" alt="image" src="https://github.com/user-attachments/assets/648dcc59-23dc-4c3a-b996-fb77b52ab905" />
  - Select *Command Line Interface (CLI), acknowledge the warning, and click **Next*:
    <img width="1104" height="843" alt="image" src="https://github.com/user-attachments/assets/65558d6e-7c4c-4282-8c20-e0e67c89efec" />
  - Enter **"ScoutSuite-Lab Audit"** when asked to set a description. This is good practice, especially for administrators that are dealing with multiple keys:
    <img width="1457" height="366" alt="image" src="https://github.com/user-attachments/assets/c378d061-3b94-47be-a691-7b1eedceaa64" />
  - *CRITICAL:* Copy the *Access Key ID* and *Secret Access Key*. Paste them into a notepad; you will need them for the aws configure step in the terminal. It is recommended that you also download the **.csv** file that contains both passwords
    <img width="1645" height="663" alt="image" src="https://github.com/user-attachments/assets/032d7e19-8812-4711-93e5-05ac35622278" />
  - Oonce you have stored the passwords, click **"done"**.
-----


### Phase 3: Environment Setup & Performing the AWS Security Audit

Now, we need to activate our tools, authenticate with the cloud, and run the audit.

- Navigate to the Workspace & Activate the Environment 

```bash
cd ~/BnB/ScoutSuite
```

- Activate the virtual environment
  
```bash
source venv/bin/activate
```

<img width="1026" height="158" alt="image" src="https://github.com/user-attachments/assets/9e636795-ba14-439e-99d2-b498312f9af0" />


- Install Scout Suite with the environment active:


```bash
pip install scoutsuite
```

> *Good Practice - Verify the Installation:*
> Let's make sure the tool was installed correctly before moving forward.

```bash
scout --version
```
<img width="808" height="53" alt="image" src="https://github.com/user-attachments/assets/4e381838-3cbb-4ec1-bd34-aa21cd73019a" />


- Authentication (AWS CLI)
    We must authenticate our local VM with the AWS Cloud using the credentials generated in Phase 2.
  
```bash
aws configure
```

Fill in the prompts exactly as you saved them (press Enter after each):

  * *AWS Access Key ID:* [Your Access Key from the CSV]
  * *AWS Secret Access Key:* [Your Secret Key from the CSV]
  * *Default region name:* eu-north-1 (or your specific region)
  * *Default output format:* json
    
<img width="1386" height="196" alt="image" src="https://github.com/user-attachments/assets/f17e183f-41f3-47e2-85a4-ee7e8394dc38" />

- Test the Connection
    Before launching a complex scanner, it is crucial to verify that our terminal is successfully communicating with AWS and that we are recognized as the scout-auditor.


```bash
aws sts get-caller-identity
```

<img width="927" height="151" alt="image" src="https://github.com/user-attachments/assets/2f350238-ce16-4851-8d04-e8e50c44473e" />


- Execute the Security Audit
    It's time to run the scanner. We will specify aws as our target cloud provider. Scout Suite will now fetch configuration data across the active services.


```bash
scout aws
```

<img width="1841" height="887" alt="image" src="https://github.com/user-attachments/assets/28dc80b0-9598-415d-811e-f8b90b766276" />

>[!TIP]
> The **"This AWS Access Key Id needs a subscription for the service"** error is expected, we only have a few services set up on this account

- **Analyze the HTML Report:**
    Once the scan is complete, an interactive HTML report is generated locally. It should open in your browser automatically. 

<img width="1849" height="1045" alt="image" src="https://github.com/user-attachments/assets/56d14f53-1e14-4507-b6ba-3ef2918decba" />


```bash
ls -lh scoutsuite-report
```

### *Scoutsuite* allows us to see: 
 - Every service running on the AWS account;
 - How many critical vulnerabilities ScoutSuite found for each service
 - The total number of checks and the number of passed tests / failed tests for each service

> Naturally, just knowing what is vulnerable is not enough. ScoutSuite provides for each warning a detailed description of the problem and recommended remediation steps.


- We will first check the **EC2** instance. Click on it to see the exact warnings *ScoutSuite* triggered:

<img width="653" height="724" alt="image" src="https://github.com/user-attachments/assets/691749a2-fcfd-4f17-8fe0-69eeb39679c0" />

- Here we can see every warning and test ScoutSuite ran. As expected, the **dangerous vulnerability** we set up in *Phase 2* (open port) is at the top of the list: 
 <img width="1387" height="891" alt="image" src="https://github.com/user-attachments/assets/5e60a587-7ccc-41be-bb68-7d50d62fccd2" />

- To see a detailed description and the recommended remediation steps, click on the **+** symbol:
<img width="1347" height="327" alt="image" src="https://github.com/user-attachments/assets/62df7a45-daca-4e02-9cf2-13c39089b8d7" />
<img width="1349" height="552" alt="image" src="https://github.com/user-attachments/assets/d96b589c-7848-41dd-a95c-439fe96eed82" />

- Now let's check the **IAM** service. Go back a page and slect **IAM**: 
<img width="1406" height="765" alt="image" src="https://github.com/user-attachments/assets/fe50c0e5-877f-4eda-8fb5-10d7b90a6d30" />

- As expected, all warnings are password / MFA related. In a real situation, this could be a simple configuration error, yet it is a critical vulnerability.
<img width="1343" height="704" alt="image" src="https://github.com/user-attachments/assets/851fe1d1-2cd1-43aa-a3f3-28b24de1020a" />

- Now to check the **S3 bucket**, go back a page, scroll down and click on **S3**: 
<img width="1366" height="850" alt="image" src="https://github.com/user-attachments/assets/da8dbafe-fcbc-4cbe-8e6c-ced7ad71d49b" />

>[!TIP]
> The **"Bucket Access Logging Disabled"** warning means that if someone manages to steal information from the *S3 Bucket* **you will not have any logs or proof of the illicit data retrieval**.
> Activating *Bucket Access Logging*, like most of those configurations, is done through the *AWS service console*, and provides a way to check bucket request history.


## Lab Conclusion: AWS Security Auditing with ScoutSuite
- The primary value of ScoutSuite lies in its ability to consolidate thousands of complex AWS settings into a single, actionable HTML report. This transforms raw configuration data into a prioritized roadmap for security remediation, allowing administrators to close critical security gaps before they are exploited.

<br></br>

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Unauthorized_Cloud_Access.md)
