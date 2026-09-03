![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# GoPhish

#### Please use the Ubuntu VM

<hr>

## Lab Objective

This lab demonstrates **what GoPhish can do** from both an attacker and defender perspective.<br>
You will **launch a phishing campaign**, and **observe captured credentials and events**.


In this lab you will:
- Launch the GoPhish web interface
- Create a basic phishing campaign
- Capture submitted credentials
- Analyze campaign results

---

## Step 1: Start GoPhish

To begin, lets open a terminal.

![](/IntroClassFiles/Tools/IntroClass/attachmentsfornewlabs/terminalinubuntu.png)

Then run the following:

```
cd ~/BnB/gophish
```

```bash
sudo ./gophish
```

You should see output similar to `Starting admin server at http://0.0.0.0:3333`

<img width="1165" height="276" alt="2026-03-17_22-40" src="https://github.com/user-attachments/assets/b530c26d-c4a6-4d4d-945a-3ecfa4a14419" />


>[!IMPORTANT]
>Leave this terminal open

<hr>

## Step 2: Access the Admin Panel

Open a browser and go to:

```
https://localhost:3333
```

<img width="563" height="536" alt="image" src="https://github.com/user-attachments/assets/949def60-dbea-431b-affd-1ad2c58d330e" />


### Default credentials:
- **Username:** admin
- **Password:** (shown in terminal output)


<img width="1189" height="177" alt="2026-03-17_22-43" src="https://github.com/user-attachments/assets/193cc5bd-35a5-4ca9-a602-a69a1064b24b" />


Copy the password from the terminal and log in.

- Make your own password afterwards:

<img width="574" height="684" alt="image" src="https://github.com/user-attachments/assets/fb7954db-7c5e-4933-a710-405037ab9dc8" />

---

## Step 3: Create a Sending Profile

Start by clicking **Sending Profiles** in the **left** tab:

<img width="329" height="55" alt="image" src="https://github.com/user-attachments/assets/2aa9f0ba-4567-444e-8862-15ce973d7003" />

Then, click **New Profile**:

<img width="153" height="73" alt="image" src="https://github.com/user-attachments/assets/342a74e4-7ac4-4b68-a530-0a453b1cf1da" />

Fill in the following info:
   - Name: `Local SMTP`
   - Host: `127.0.0.1:1025`
   - From: `IT Support <it@company.local>`

Afterwards, click **Save**.

>[!NOTE]
>We are using port `1025` because that's the port where **MailHog** will be serving and listening

---

## Step 4: Create a Landing Page (Credential Capture)

Let's start by clicking **Landing Pages**:

<img width="331" height="68" alt="image" src="https://github.com/user-attachments/assets/03e2b2a3-db91-4be2-8bd9-f2411b6c27b2" />

Now, click **New Page**

<img width="127" height="62" alt="image" src="https://github.com/user-attachments/assets/c7564680-68ba-4114-9b21-0e8f386d2bda" />

Use the name: `Fake Login`

<img width="228" height="99" alt="image" src="https://github.com/user-attachments/assets/89a40847-1009-4fe2-98c5-c613bc457f6e" />

For the HTML Content, enter the following:

```html
<h2>Company Login</h2>
<form method="POST">
  <input name="username" placeholder="Username"><br><br>
  <input name="password" type="password" placeholder="Password"><br><br>
  <button type="submit">Login</button>
</form>
```

Click **Save Page**.

---

## Step 5: Create an Email Template

This time, start off by clicking **Email Templates**:

<img width="326" height="64" alt="image" src="https://github.com/user-attachments/assets/96522c2f-5d63-4dd2-bf4a-344ab2f705fd" />

Next, click **New Template**:

<img width="160" height="64" alt="image" src="https://github.com/user-attachments/assets/5b8e4d53-bb30-4dc8-8597-79cac373fad6" />

Enter the name: `Password Reset`
Enter the subject: `Urgent Password Reset`
Enter the following in the body(HTML):

```html
<p>Your password is expiring.</p>
<p><a href="{{.URL}}">Click here to reset it</a></p>
```

Then, click **Save Template**.

---

## Step 6: Create a User Group

Begin by clicking **Users & Groups**:

<img width="333" height="72" alt="image" src="https://github.com/user-attachments/assets/d964a536-e704-4a8a-bb02-ab1e9edd1d86" />

Then, click **New Group**

<img width="141" height="58" alt="image" src="https://github.com/user-attachments/assets/f62ff2a3-43d5-4985-a15c-cd5075b1d053" />

Enter the Name: `Test Users`

Then enter the following:
   - First Name: `Test`
   - Last Name: `User`
   - Email: `test@company.local`

After, click **+Add**

<img width="107" height="59" alt="image" src="https://github.com/user-attachments/assets/6cd813f4-d826-491e-86bd-d4776aeb6b7c" />

Finally, click **Save Changes**

---

## Step 7: Run MailHog

Now, open another terminal and run the following command:

```bash
MailHog
```

<img width="609" height="162" alt="2026-03-17_22-53" src="https://github.com/user-attachments/assets/825f0fe2-54cf-4f3d-878f-083d104cfbb5" />

<hr>

## Step 8: Launch a Phishing Campaign

Click **Campaigns**

<img width="328" height="63" alt="image" src="https://github.com/user-attachments/assets/b689bf15-cc9d-4fd8-a63e-82c3a03aeab2" />

Next, click **New Campaign**

<img width="163" height="61" alt="image" src="https://github.com/user-attachments/assets/25f5651a-a932-4e9e-b46b-9a7e227b0e8f" />

Enter the Name: `Demo Campaign`

Now select:
   - Email Template: `Password Reset`
   - Landing Page: `Fake Login`
   - Sending Profile: `Local SMTP`
   - Users Group: `Test Users`

Then, click **Launch Campaign**

---

Now go back to the **MailHog Terminal**.

You should see the new mail

<img width="1898" height="1005" alt="2026-03-17_23-06" src="https://github.com/user-attachments/assets/7766f585-34b3-4e3b-bb58-698dc8fbc071" />

<hr>

## What we get out of it?

1. Sender and recipient accepted
```
MAIL FROM:<it@company.local>
RCPT TO:<test@company.local>
250 ok
```

<br>

2. Email content delivered
```
DATA
Subject: Urgent Password Reset
X-Mailer: gophish
```

<br>

3. Email stored by MailHog
```
Storing message nYyPFT2-foO9BZ2z...
250 Ok: queued
```

<br>

4. Body of the email
```
<p>Your password is expiring.</p>
<p><a href=3D"?rid=3DzKNkt2x">Click here to reset it</a></p>'
```

...and more very in depth details