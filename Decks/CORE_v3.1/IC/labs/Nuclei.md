![image](/FilesForLabs/images/blueantisyphon.png)

# Nuclei

# Ubuntu VM

## Lab Goal

This lab introduces **Nuclei**, a fast vulnerability scanner based on templates.
You will:
- Deploy OWASP Juice Shop (intentionally vulnerable app)
- Run basic Nuclei scans
- Understand results from both attacker and defender perspectives

---

## Run OWASP Juice Shop

Pull and run Juice Shop:
```bash
sudo docker run -d -p 3000:3000 bkimminich/juice-shop:v10.3.0
```

Verify it is running:
```bash
sudo docker ps
```

<img width="1740" height="98" alt="juiceShopRunning" src="https://github.com/user-attachments/assets/58114df2-8f49-4468-aec6-3c60dc898a47" />



Open your browser and go to:
```
http://localhost:3000
```

<img width="1915" height="1050" alt="image" src="https://github.com/user-attachments/assets/43bcd849-e417-46c8-a831-c661f47fe6e0" />


You should see the OWASP Juice Shop homepage

---

## Download Nuclei Templates

Nuclei uses templates to detect vulnerabilities.

```bash
nuclei -update-templates
```

Templates are stored in:
```bash
~/.local/nuclei-templates
```

---

## First Scan (Basic Detection)

Run a simple scan against Juice Shop:
```bash
nuclei -u http://localhost:3000
```

Observe:
- Detected technologies
- Exposed endpoints
- Informational findings

<img width="1920" height="842" alt="image" src="https://github.com/user-attachments/assets/49a53167-c44c-4862-82dc-dcb2ebd3ad9c" />

This is passive recon-style scanning

---

## Run Vulnerability Templates

Now run only vulnerability-related templates:
```bash
nuclei -u http://localhost:3000 -tags vuln
```

You may see:
- Missing security headers
- Misconfigurations
- Known vulnerable patterns

---

## Filter a scan to only show specific severities

```bash
nuclei -u http://localhost:3000 -severity info
```

---

## Save Scan Results

Run scan and save output:
```bash
nuclei -u http://localhost:3000 -severity info -o results.txt
```

View results:
```bash
cat results.txt
```

This is how defenders:
- Review **findings**
- Prioritize **risks**
- Feed **SIEM** / **reports**



---

# Finished?

[Back to Compromised_Web_Server's Main Page](/Decks/CORE_v3.1/IC/Compromised_Web_Server.md)

[Back to External_Service_Exploitation's Main Page](/Decks/CORE_v3.1/IC/External_Service_Exploitation.md)

---

> Created by Turcu-Stiolica Alexandru
