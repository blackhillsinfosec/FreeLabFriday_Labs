![image](/FilesForLabs/images/blueantisyphon.png)

# OSINT

# Ubuntu VM

## In this lab we will
- Harvest emails, subdomains, and IPs from public sources using **theHarvester**
- Hunt usernames across dozens of social platforms using **Sherlock**
- Extract DNS and domain ownership data using **WHOIS** and **dig**
- Understand what an attacker (or analyst) can find without touching a target

---

## Tool 1 - theHarvester

theHarvester collects emails, subdomains, IPs, and URLs from public sources like Google, Bing, and various DNS databases.

### What sources does theHarvester use?

List all available data sources:

```bash
theHarvester -d hackthissite.org -b all -l 10
```

You will see sources like `crtsh`, `dnsdumpster`, `virustotal`, and more. Each one is a different public service being queried. For many, you will need API keys for full functionality

---

### Harvesting a domain - subdomains

Let's run a basic subdomain harvest against `hackthissite.org` using the `crtsh` source (Certificate Transparency logs - completely passive):

```bash
theHarvester -d hackthissite.org -b crtsh
```

You will see a list of subdomains like:

<img width="688" height="841" alt="image" src="https://github.com/user-attachments/assets/0eb5dce1-9414-4302-940e-bbf7fa0b4c61" />



These are pulled from SSL certificate logs

---

### Harvesting historical URLs

The Wayback Machine and Common Crawl are public archives that have been indexing the internet for decades. theHarvester can query them to find old URLs, forgotten endpoints, and pages that may no longer be linked anywhere:

```bash
theHarvester -d hackthissite.org -b waybackarchive,commoncrawl -l 100
```

You will see URLs or subdomains like:

<img width="952" height="726" alt="image" src="https://github.com/user-attachments/assets/c69ea3cf-c399-42c2-8ce7-387ae8ae60dd" />


Why does this matter? Old URLs can reveal forgotten admin panels, legacy login pages, deprecated API endpoints, or backup files that were never removed. Attackers look for these because they are often unpatched and unmonitored. An analyst can use this to build a list of endpoints to review during a security assessment.

---

## Tool 2 - Sherlock

Sherlock searches over 300 social platforms and websites for a given username. It tells you where that username exists.

### Search for a username

Let's search for the username `johndoe`:

```bash
sherlock johndoe
```

Sherlock will check hundreds of sites and print results like:

<img width="1913" height="971" alt="image" src="https://github.com/user-attachments/assets/eeff70e9-796a-4ada-b012-bc6b5b3142e9" />


A `[+]` means the profile exists. A `[-]` means it does not.

---

### Search for multiple usernames at once

```bash
sherlock alice bob charlie
```

Useful when a target uses multiple aliases - you check all of them in one command.

---

### Why does this matter?

Imagine an attacker finds a username from a data breach. With Sherlock they can:
- Find the target's LinkedIn -> job history, colleagues
- Find their GitHub -> leaked API keys, internal repos
- Find their Reddit -> personal details, location clues

All in under a minute.

---

## Tool 3 - WHOIS + dig

These tools are built into every Linux system and give you domain ownership, registrar info, DNS records, and server IPs.

### WHOIS - Who owns a domain?

```bash
whois github.com
```

<img width="918" height="574" alt="image" src="https://github.com/user-attachments/assets/60b9867a-50b3-4b03-9d97-70a89f870457" />


Look for:
- **Registrant** - who registered the domain
- **Registrar** - where it was registered (GoDaddy, Namecheap, etc.)
- **Creation Date** - how old the domain is (new domains are suspicious)
- **Name Servers** - where DNS is hosted

```bash
whois hackthissite.org | grep -E "Registrar|Creation|Name Server|Registrant"
```

This filters the output to only the most relevant lines.

---

### WHOIS on an IP address

You can also run WHOIS on an IP to find who owns that IP block:

```bash
whois 8.8.8.8
```

<img width="1178" height="880" alt="image" src="https://github.com/user-attachments/assets/5cf51f18-20af-423e-96a8-1e1003a6571f" />


You will see it belongs to Google. Try:

```bash
whois 1.1.1.1
```

<img width="757" height="887" alt="image" src="https://github.com/user-attachments/assets/1f966155-9997-4bc6-a6e7-48ec4f699fda" />

This belongs to Cloudflare. Knowing who owns an IP helps during incident response - is the traffic going to AWS, a VPS provider, or a residential ISP?

---

### dig - DNS record enumeration

`dig` queries DNS servers directly.

Get the A record (IP address) of a domain:

```bash
dig hackthissite.org A
```

<img width="809" height="536" alt="image" src="https://github.com/user-attachments/assets/cff5efd4-5535-4dc4-bd4e-c4159fa307dd" />


Get all mail servers (MX records):

```bash
dig hackthissite.org MX
```

<img width="807" height="579" alt="Screenshot 2026-05-17 232008" src="https://github.com/user-attachments/assets/d4ef8a46-36af-4a4c-b2ca-3f3f744a7adc" />

Get name servers:

```bash
dig hackthissite.org NS
```

<img width="700" height="540" alt="2026-05-18_15-24" src="https://github.com/user-attachments/assets/2aea08b7-ab2e-45e7-8bb6-8144f90c385c" />


Get the TXT records (often contains SPF, DKIM, verification tokens):

```bash
dig hackthissite.org TXT
```

<img width="1902" height="535" alt="2026-05-18_15-26" src="https://github.com/user-attachments/assets/5a5159e0-6d7d-4124-9940-8f463a685896" />

TXT records can leak internal information - verify tokens, third-party integrations, sometimes internal hostnames.

---

### Query a specific DNS server

Instead of using your ISP's DNS, query Google's directly:

```bash
dig @8.8.8.8 hackthissite.org A
```

<img width="828" height="558" alt="2026-05-18_15-27" src="https://github.com/user-attachments/assets/3a7f28f8-0b23-4f8e-8dcf-e458013397cb" />


This is useful when you want to bypass local DNS caching or test DNS propagation.

---

### Reverse DNS lookup

Given an IP, find what hostname it resolves to:

```bash
dig -x 1.1.1.1
```

This is the reverse of a normal DNS query. Useful for identifying what a suspicious IP belongs to during log analysis.

---

### Combine it all - a full manual recon run

Here is a mini recon workflow you would run against a target domain. Use `hackthissite.org` as the example:

```bash
echo "=== WHOIS ===" && whois hackthissite.org | grep -E "Registrar|Creation|Name Server"
echo "=== A RECORD ===" && dig hackthissite.org A +short
echo "=== MX RECORDS ===" && dig hackthissite.org MX +short
echo "=== TXT RECORDS ===" && dig hackthissite.org TXT +short
echo "=== NAME SERVERS ===" && dig hackthissite.org NS +short
```

Run this as a one-liner. You now have a quick DNS profile of the target in seconds.

---

## What to think about

- Everything in this lab used **publicly available data**
- OSINT is the first phase of almost every real-world attack
- As a defender, run these tools against **your own organization** periodically to see what attackers see
- If theHarvester finds internal-looking subdomains, leaked emails, or dev/staging servers exposed to the internet - that is a finding worth reporting



---

# Finished?

[Back to Card's Main Page](../Social_Engineering.md)

---

> Created by Turcu-Stiolica Alexandru
