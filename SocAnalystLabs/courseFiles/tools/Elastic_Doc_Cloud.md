![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

Elasticsearch is a distributed search and analytics engine, scalable data store, and vector database built on Apache Lucene. It’s optimized for speed and relevance on production-scale workloads. Use Elasticsearch to search, index, store, and analyze data of all shapes and sizes in near real time. Kibana is the graphical user interface for Elasticsearch. It’s a powerful tool for visualizing and analyzing your data, and for managing and monitoring the Elastic Stack.

Elasticsearch is the heart of the Elastic Stack. Combined with Kibana, it powers these Elastic solutions and use cases:
- **Elasticsearch** - Build powerful search and RAG applications using Elasticsearch's vector database, AI toolkit, and advanced retrieval capabilities
- **Observability** - Resolve problems with open, flexible, and unified observability powered by advanced machine learning and analytics
- **Security** - Detect, investigate, and respond to threats with AI-driven security analytics to protect your organization at scale

### Let's go through setting it all up
1. **Make an account** - [Here](https://cloud.elastic.co/registration?fromURI=%2Fhome) , You can start a free trial for 14 days to experiment and learn this tool, you also don't need a credit card to get started

<img width="584" height="619" alt="image" src="https://github.com/user-attachments/assets/6029f8b7-b548-4576-bcac-bad7c59bff67" />

<br><br>

2. Insert your name and you can leave a `-` in the Company field

<img width="508" height="408" alt="image" src="https://github.com/user-attachments/assets/13e1954b-90c0-4d27-9ec6-186cb2b1b6df" />

<br><br>

3. Select **I am new to Elastic**

<img width="508" height="408" alt="image" src="https://github.com/user-attachments/assets/8a7efadb-1de5-49f3-9bc5-f8aae21a367e" />


<br><br>

4. Select **Considering Elastic Cloud subscription for production / proof of concept**

<img width="548" height="514" alt="image" src="https://github.com/user-attachments/assets/c2833e3d-9b33-4d2c-8ffb-d9a46ab2bd7c" />

<br><br>

5. Select **Elastic for Security**

<img width="911" height="644" alt="image" src="https://github.com/user-attachments/assets/839d56d3-1cf6-41b2-8429-2a49bc1015fc" />

<br><br>


7. Select **SIEM and Security Analytics**

<img width="514" height="386" alt="image" src="https://github.com/user-attachments/assets/b82366e6-ddc1-4a71-85c8-7622e8bd2978" />

<br><br>

8. Select **No**

<img width="514" height="386" alt="image" src="https://github.com/user-attachments/assets/c42f6f26-5aac-40ec-b038-e5b9053d4b56" />

<br><br>

9. Select **Elastic cloud hosted**

<img width="467" height="563" alt="image" src="https://github.com/user-attachments/assets/a47110ef-9e37-4ebf-b011-07b2ed0ab061" />

<br><br>

10. Click **Launch** and while it's setting up you can go over to the next steps

<img width="487" height="336" alt="image" src="https://github.com/user-attachments/assets/a503b8c8-4680-49d7-9adf-32c0160958b5" />

<br><br>

11. Download Sysmon from [Microsoft Sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon) and extract it into downloads

<img width="1212" height="685" alt="image" src="https://github.com/user-attachments/assets/cbb68fb5-3fd0-46de-a030-c6085fa33e49" />


<br><br>

12. **In powershell run** 

```bash
cd C:\Users\Administrator\Downloads\Sysmon\
```

```bash
.\Sysmon64.exe -accepteula -i
```

13. To set up the Elastic Agent on the machine go to **Data Management -> Integrations** in the lower left

<img width="363" height="562" alt="image" src="https://github.com/user-attachments/assets/78c5148a-4702-4b68-a44b-41b09b5f0455" />


<br><br>

14. Search for **Windows** and select **Windows**

<img width="1232" height="756" alt="image" src="https://github.com/user-attachments/assets/43647230-453d-446e-8250-37e5dd52dc69" />

<br><br>

15. Now click on **Add Windows**

<img width="1232" height="756" alt="image" src="https://github.com/user-attachments/assets/c642cea4-1e17-494b-971d-30b084d2d137" />

<br><br>

16. Now press on the **Install Elastic Agent** on the popup in the lower middle part of the screen

<img width="819" height="73" alt="image" src="https://github.com/user-attachments/assets/3ff9ff70-0009-4735-b3e0-fe737e046774" />
<br><br>

17. Select **Windows** and run that command in powershell to install the agent, then go back in the browser and press **Add the integration**

<img width="1162" height="1006" alt="image" src="https://github.com/user-attachments/assets/74810255-b48a-4487-b1dc-9cbf4767af2f" />
<br><br>

18. Scroll down and make sure you have **Sysmon Operational** ticked

<img width="792" height="508" alt="image" src="https://github.com/user-attachments/assets/076b2dad-2880-4e6f-8276-43f95edfe9d1" />
<br><br>

19. Click **Confirm incoming data**, you should see a preview of incoming data

<img width="1162" height="1006" alt="image" src="https://github.com/user-attachments/assets/ccbc1101-4749-496b-8604-046dc8664a26" />

<br><br>

## That's it!

As a continuation, take onto the hands-on lab for [Elastic](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/elasticLabCloud.md)


---
[Back to the Section](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/toolsAndPlatforms.md)


---

> Created By Turcu Știolică Alexandru - Black Hills Information Security

