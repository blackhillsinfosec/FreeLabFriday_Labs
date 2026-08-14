<img width="300" height="414" alt="BNB_CARDS_v3_45" src="https://github.com/user-attachments/assets/51f177f0-5f6d-4013-8533-d81c047b05f2" />

# Permissions Audit


Every system has users, and every user has permissions. A **permissions audit** is how defenders figure out who can access what - and whether that access makes any sense.

The goal is simple: find accounts and roles that have more access than they should. In practice, that turns out to be surprisingly common.

---

## Why Excessive Permissions Are a Problem

When someone's account gets compromised, the attacker inherits whatever that account could do. If the account had admin rights across the whole domain, so does the attacker.

This is why least-privilege matters. Every user should only have the access they actually need for their job - nothing more.

The most common issues found in a permissions audit:

- Service accounts with domain admin rights
- Employees who changed roles but kept their old access
- Shared accounts (everyone knows the password, no one's accountable)
- Local admin rights handed out to avoid helpdesk tickets
- Cloud IAM roles that allow way more than intended

Most of these aren't intentional. They build up over time because nobody cleaned them up.

---

## Where Permissions Live

Depending on the environment, permissions can be spread across a lot of places:

**Active Directory** - controls who can log in, access file shares, run scripts, join machines to the domain, and more. Group memberships here have a huge blast radius if misconfigured.

**Cloud IAM (AWS, Azure, GCP)** - defines what users and services can do inside cloud environments. An overpermissioned IAM role in AWS can mean an attacker reads your S3 buckets or spins up infrastructure on your bill.

**File systems** - local folders and network shares often have ACLs that haven't been reviewed since they were created. Sensitive data ends up readable by the entire company.

**Azure AD / Entra ID** - manages identities for Microsoft 365, Azure services, and any app using SSO through Microsoft. Roles like Global Admin or Application Administrator carry serious risk if abused.

---

## What Attackers Do With Excessive Permissions

Once an attacker gets into any account - even a low-privilege one - the next step is almost always privilege escalation. They look for paths to higher access.

BloodHound was literally built to map these paths automatically. It can show you, visually, how an attacker could hop from a regular helpdesk account to Domain Admin in three steps - just by following trust relationships and group memberships that already exist in your AD.

That's the uncomfortable truth about permissions audits: a lot of the risk is already there. It just hasn't been exploited yet.

---

## How Defenders Do a Permissions Audit

The process usually looks like this:

1. Pull a list of all accounts and their group memberships
2. Identify accounts with elevated privileges (admin groups, privileged roles)
3. Cross-reference with HR or actual job roles - does this person need this?
4. Flag stale accounts (people who left, service accounts nobody maintains)
5. Check for attack paths using tooling like BloodHound
6. Remediate - remove access, disable accounts, tighten roles

Cloud environments add a layer of complexity because permissions are often defined in code (policies, role bindings) and can be inherited from multiple places at once.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/detections/permissions-audit?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Find the Overprivileged Account](ctfs/PA_easy-1.md)
- [Easy 2 – Stale Credentials](ctfs/PA_easy-2.md)
- [Medium – AD Attack Path](ctfs/PA_medium.md)
- [Hard – Cloud IAM Escalation](ctfs/PA_hard.md)
-->
---

## Labs

Hands-on practice with the tools from the card:

- [AD Users and Computers Lab](https://freelabfridays.com/comingsoon/)
- [BloodHound Lab](https://freelabfridays.com/comingsoon/)
- [ScoutSuite Lab](https://freelabfridays.com/labs/decks/core-v31/ic/labs/scoutsuite/scoutsuite/)
- [Prowler Lab](https://freelabfridays.com/comingsoon/)

---

Permissions problems are almost never dramatic. There's no exploit, no zero-day. Someone just has access they shouldn't, and nobody noticed until it was too late. That's what makes this kind of audit so important - and so easy to skip.
