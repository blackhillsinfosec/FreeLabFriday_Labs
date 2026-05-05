![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **SOC Core Skills** Course:

https://www.antisyphontraining.com/product/soc-core-skills-with-john-strand/

---

# PingCastle

In this lab we will be using **PingCastle** to review the security posture of an **Active Directory** environment.

**PingCastle** is a tool that rapidly identifies security misconfigurations in **Active Directory**.  
It works by running **LDAP queries** against the domain - no admin rights required - and produces a scored **HTML risk report** you can open in any browser.

> [!NOTE]
>
> PingCastle is free for personal and educational use.  
> Commercial use requires a license - but it is very affordable.

For this lab, we are **not** running PingCastle against a live domain.  
Instead, we will be reviewing a **pre-generated report** from a test environment.  
This is the same kind of report you would get if you ran it yourself.

---

## Part 1 - Open the Report

Open your browser and navigate to:

```
https://www.pingcastle.com/PingCastleFiles/ad_hc_test.mysmartlogon.com.html
```

You should see a dashboard that looks something like this - a global **risk score** at the top, followed by several risk categories below.

> [!TIP]
>
> The **lower the score, the better**.  
> A score of **0** means no issues were found in that category.  
> A score of **100** is the worst possible.

Take a moment to look at the overall score and the four category scores before moving on.

---

## Part 2 - Empty Passwords

**Where to look:** Scroll down to **User Information** -> click **Account Analysis**

Here you will find a breakdown of all user account states in the domain.

Look for the row labeled **"Accounts with an empty password"**.

You should find **two accounts** with no password set at all.

> This is about as bad as it gets. An account with no password means **anyone** - on the network or sometimes even over the internet - can authenticate as that user without knowing anything.  
> In a medical clinic, a hospital, or any environment handling sensitive data, this is an immediate critical finding.

---

## Part 3 - Passwords That Never Expire

**Where to look:** Same section - **User Information** -> **Account Analysis**

Look for **"Accounts with a password that never expires"**.

You will find several accounts configured this way.

> [!NOTE]
>
> This is extremely common in real environments - especially for **service accounts**.  
> A service account runs a background process (a database, a backup job, an AV agent) and rotating its password requires updating every system that uses it.  
> That operational pain is why admins often just tick "Password never expires" and move on.  
>
> The risk: if that account is compromised, the attacker has indefinite access with a credential that will **never** be forced to rotate.  
>
> **How to address it:** Use **Managed Service Accounts (MSAs)** or **Group Managed Service Accounts (gMSAs)** - Windows rotates their passwords automatically, so you get the convenience without the risk.

---

## Part 4 - What Does "Everyone" Actually Mean?

Before looking at the next finding, we need to understand what **Everyone** means in Active Directory - because it is not what most people assume.

In Windows, the **Everyone** group includes:

- All domain users
- All local users  
- **Unauthenticated users** - people who have not logged in at all

Yes. You read that correctly.  
**Everyone** literally means everyone, including anonymous connections.

A safer alternative is **Authenticated Users**, which restricts access to accounts that have actually proven their identity by logging in.

> [!IMPORTANT]
>
> Whenever you see **Everyone** assigned permissions anywhere in an AD environment - on a share, a GPO, an object - treat it as a finding worth investigating.  
> Nine times out of ten it was not intentional.

---

## Part 5 - Everyone Privileges

**Where to look:** Scroll to **Privileged Accounts** -> click **Privileged Accounts rule details**

Here you will see a breakdown of which principals have been granted privileged access.

Look for any entries showing **Everyone** as the assigned principal.

Granting **Everyone** any kind of elevated right means you have handed that privilege to unauthenticated users. In a live environment, this is an immediate remediation item.

---

## Part 6 - Old Passwords

**Where to look:** Scroll to **Stale Objects** -> click **Stale Objects rule details**

Here you will see accounts whose passwords have not been changed in a very long time.

> At penetration testing firms like **Black Hills Information Security**, stale passwords are one of the most reliable ways into an environment.  
> Doctors, developers, service accounts, CEOs - accounts that "can't be touched" accumulate for years.  
> A password last set in 2017 has likely been reused elsewhere, leaked in a breach, or cracked from an old dump.
>
> From a defender's perspective: **stale accounts that are no longer needed should be disabled**, and active accounts should be subject to a password policy that enforces regular rotation or - better - pushed toward **passphrase-based policies** with longer minimum lengths instead of arbitrary 90-day resets.

---

> [!TIP]
>
> In a real engagement, **PingCastle** is typically one of the first tools run after getting a domain-joined foothold.  
> The report gives you a prioritized list of weaknesses in minutes - without needing admin rights, without touching endpoints, and without triggering AV.  
> As a SOC analyst, it is equally valuable: run it quarterly and track your score over time.

---

***

<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/AZURE-MSP-WRITEUP-main/README.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ACHCEIntroClass/ACHunterCE.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
