# Authentication Logs

> **Hands-On Lab:** Put this into practice with the [Domain Log Review Lab](https://freelabfridays.com/labs/introclassfiles/tools/introclass/domainlogreview/domainlogreview/) and the [Password Spraying Lab](https://freelabfridays.com/labs/introclassfiles/tools/introclass/passwordspray/passwordspray/).

<hr>

## Overview

Authentication logs record **who tried to prove their identity, when, from where, and whether it worked**.<br>
Since most attacks eventually involve logging in with stolen or guessed credentials, these are some of the most valuable logs a SOC analyst can review.

Authentication logs typically capture:

- **Successful logins**
- **Failed login attempts**, along with the reason they failed
- **Login errors**, such as locked or disabled accounts and expired passwords
- **Logouts**, including whether the user logged out manually or the session expired
- **Context**: source IP, device, user agent, geolocation, application, and whether MFA was used

<hr>

## Authentication vs. Authorization

These two are easy to confuse, but they answer different questions.

| | Authentication (AuthN) | Authorization (AuthZ) |
|---|---|---|
| **Question** | *Who are you?* | *What are you allowed to do?* |
| **Example event** | User `jsmith` logged in from `198.51.100.24` | User `jsmith` opened `\\FS01\Finance\Payroll.xlsx` |
| **Tells you** | That an account was used | What the account accessed or changed |
| **In an incident** | Detects the compromise | Determines the **blast radius** |

Authentication logs help you spot the breach: for example, hundreds of failed logins followed by a success.<br>
They do **not** tell you what the attacker did with that account afterward. For that you need **authorization and audit logs**, which show file access, share access, API calls, and permission changes.<br>
Together they answer: *"Which account was compromised, and what could it reach?"*

<hr>

## Where Authentication Logs Come From

### Windows / Active Directory
Found in the **Security** log on workstations, servers, and especially **domain controllers**.

| Event ID | Meaning |
|---|---|
| **4624** | Successful logon |
| **4625** | Failed logon |
| **4634 / 4647** | Logoff / user-initiated logoff |
| **4648** | Logon with explicit credentials |
| **4672** | Admin privileges assigned at logon |
| **4740** | Account locked out |
| **4768** | Kerberos TGT requested (the initial domain logon) |
| **4769** | Kerberos service ticket requested |
| **4771** | Kerberos pre-authentication failed |
| **4776** | NTLM credential validation |

<br>

### Linux
| Location | Distribution |
|---|---|
| `/var/log/auth.log` | Debian / Ubuntu |
| `/var/log/secure` | RHEL / CentOS / Fedora |
| `journalctl -u ssh` (or `-u sshd`) | systemd-based systems |
| `last` / `lastb` | Successful (`wtmp`) and failed (`btmp`) login history |

Sample `auth.log` entries:

```
Mar 14 02:17:41 web01 sshd[2211]: Failed password for invalid user admin from 203.0.113.77 port 51122 ssh2
Mar 14 02:17:44 web01 sshd[2213]: Failed password for root from 203.0.113.77 port 51130 ssh2
Mar 14 02:19:02 web01 sshd[2290]: Accepted password for deploy from 203.0.113.77 port 51544 ssh2
```

That last line is the one to worry about: the same IP that was guessing passwords finally got in.

### Cloud and Identity Providers
| Platform | Log Source |
|---|---|
| **Microsoft Entra ID (Azure AD)** | Sign-in logs, plus audit logs for changes |
| **Okta** | System Log |
| **Google Workspace** | Login audit log |
| **AWS** | CloudTrail (`ConsoleLogin`, `AssumeRole`) |

Cloud sign-in logs often include rich context such as **location, device, user agent, MFA result, and conditional access outcome**, which makes them very useful for spotting account takeover.

<hr>

## Attack Patterns to Recognize

### Brute Force
Many failed attempts against **one account**.
- Windows: a burst of **4625** events (Sub Status `0xC000006A`), often ending in **4740** (lockout)
- Linux: repeated `Failed password for <user>` from one IP

### Password Spraying
A **few** attempts against **many accounts**, usually with one common password, to avoid lockouts.
- Windows: 4625 or 4771 events across dozens of usernames from a single source
- Cloud: many sign-in failures for different users from the same IP or ASN

### Credential Stuffing
Using username/password pairs leaked from other breaches. Look for many different usernames tried from a pool of IPs, with occasional successes.

### MFA Fatigue (Push Bombing)
An attacker who already has the password sends repeated MFA push requests until the user approves one.
- Look for many MFA denials or timeouts for one user, followed by an approval.

### Impossible Travel
A user signs in from Chicago, then from Frankfurt 20 minutes later. One of those sessions is not the real user.

### Kerberoasting
Attackers request service tickets for accounts with SPNs, then crack them offline.
- Look for a spike in **4769** events from one account, especially with **Ticket Encryption Type `0x17` (RC4)**.

### AS-REP Roasting
Targets accounts that don't require Kerberos pre-authentication.
- Look for **4768** events with **Pre-Authentication Type `0`**.

### Suspicious Successful Logons
Sometimes the success is the alert:
- Logons outside business hours
- RDP (logon type **10**) to servers that are normally never accessed interactively
- Logons from disabled, terminated, or service accounts behaving like humans
- A first-ever logon from a new country or device

<hr>

## Investigating a Suspicious Login

Use this checklist when an authentication alert fires:

1. **Who?** Which account? Is it privileged? Is it a service account?
2. **From where?** Source IP, hostname, geolocation. Is it internal, VPN, or a hosting provider?
3. **How?** Logon type, protocol (NTLM or Kerberos), MFA used or not?
4. **What happened before?** Failed attempts from the same source? Against other accounts?
5. **What happened after?** Admin privileges (4672)? New processes? File or share access? Mailbox rules? This is where **authorization logs** define the blast radius.
6. **Is this normal?** Compare it to the user's typical logon times, locations, and devices.

<hr>

## Quick Queries

**Windows: count failed logons by account**
```powershell
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} |
  ForEach-Object { ([xml]$_.ToXml()).Event.EventData.Data |
    Where-Object Name -eq 'TargetUserName' | Select-Object -ExpandProperty '#text' } |
  Group-Object | Sort-Object Count -Descending | Select-Object -First 10
```

**Linux: top source IPs for failed SSH logins**
```bash
grep "Failed password" /var/log/auth.log | grep -oE 'from [0-9.]+' | sort | uniq -c | sort -nr | head
```

**Linux: successful logins**
```bash
grep "Accepted" /var/log/auth.log
last -a | head -20
```

<hr>

## Check Your Understanding

1. You see 40 failed logons for 40 different users from one IP, then one success. What attack is this, and what should you check next?
2. Authentication logs show that an account was compromised. Which type of log tells you what the attacker accessed with it?
3. Which Windows Event ID and field would you check to spot Kerberoasting?
4. A user approves an MFA prompt after denying 25 of them in five minutes. What is likely happening?

<details>
<summary>Answers</summary>

1. Password spraying. Check what the successful account did next: privileges, hosts accessed, and files touched.
2. Authorization and audit logs (file/share access, API calls, permission changes). These define the blast radius.
3. Event ID 4769, looking for unusual volume and Ticket Encryption Type `0x17` (RC4).
4. MFA fatigue / push bombing. The attacker likely already has the password.

</details>
