<img width="300" height="414" alt="BNB_CARDS_v3_03" src="https://github.com/user-attachments/assets/cfb56f4f-05a8-4854-a780-aa706dc47ed9" />

# Unauthorized Cloud Access

When an **attacker** accesses **SaaS platforms** or **cloud infrastructure** without authorization, it is known as unauthorized cloud access. Cloud servers, storage, identities, and business apps like file sharing and email could all be examples of this.

Because **cloud platforms** rely heavily on identity and permissions and are exposed to the internet, a single error can quickly grant attackers widespread access.

------------------------------------------------------------------------

## How Cloud Environments Usually Get Compromised

Most cloud attacks follow a familiar pattern:

-   The attacker steals or guesses valid credentials
-   Uses those credentials to log in normally
-   Abuses excessive permissions
-   Expands access across the cloud environment
-   Hides activity in logs or creates persistence

The most common causes are:

-   Phishing and credential theft
-   Weak or missing multi-factor authentication (MFA)
-   Leaked API keys and access tokens
-   Overly permissive IAM roles
-   Misconfigured cloud services and storage

In many cases, no malware is needed---everything is done using
legitimate cloud features.

------------------------------------------------------------------------

## What Attackers Do After Gaining Cloud Access

Once inside the cloud environment, attackers may:

-   Steal data from cloud storage and SaaS apps
-   Create new users or API keys for persistence
-   Disable security controls and logging
-   Deploy malicious virtual machines
-   Pivot into on-prem or other cloud resources

Because cloud access often equals administrative control, the impact can
be immediate and severe.

------------------------------------------------------------------------

## How Unauthorized Cloud Access Is Detected

Detection usually relies on visibility into identity, logs, and
behavior:

-   SIEM log analysis
-   Cloud audit and event logs
-   Permissions and IAM reviews
-   User and Entity Behavior Analytics (UEBA)

Suspicious logins, abnormal API usage, and sudden permission changes are
common early warning signs.

------------------------------------------------------------------------

## CTF Challenges

You will solve four challenges based on real cloud attack scenarios:

-   [Easy 1 - Suspicious Cloud Login](ctfs/UCA_easy-1.md)
-   [Easy 2 - Exposed API Key](ctfs/UCA_easy-2.md)
-   [Medium - Privilege Escalation in the Cloud](ctfs/UCA_medium.md)
-   [Hard - Full Cloud Environment Takeover](ctfs/UCA_hard.md)

------------------------------------------------------------------------

## Labs

Hands-on labs using real cloud attack and investigation tools:

-   [GraphRunner Lab](labs/graphrunner.md)
-   [ROADtools Lab](labs/roadtools.md)
-   [ScoutSuite Lab](labs/scoutsuite.md)
-   [Pacu Lab](labs/pacu.md)

------------------------------------------------------------------------

Unauthorized cloud access is one of the fastest ways attackers take control of modern organizations. Understanding how it happens and how to spot it is a core defensive skill for anyone working with cloud systems.



***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Cards/IC/Insider_Threat.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Cards/IC/Compromised_Web_Server.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
