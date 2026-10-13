## Full Cloud Intrusion

You are a SOC analyst. It is Friday afternoon. A Falco alert fires, then another, then your SIEM starts correlating events across three different services. You open the investigation.

Below is what you have — logs pulled from CloudTrail, VPC Flow Logs, and S3 access logs, spanning 90 minutes.

---

### Phase 1 - Initial Access (14:03-14:11)

```
[14:03] GetObject: s3://company-terraform-state/prod.tfstate  
        Principal: AKIA3EXAMPLE7XQZABCD (access key, no MFA)  
        Source IP: 91.108.4.200  

[14:09] ConsoleLogin: FAILED  
        UserName: admin  
        Source IP: 91.108.4.200  

[14:11] ConsoleLogin: SUCCESS  
        UserName: svc-terraform  
        Source IP: 91.108.4.200  
```

The Terraform state file contains plaintext database passwords and internal hostnames. The `svc-terraform` account uses an API key stored in that state file.

---

### Phase 2 - Enumeration & Escalation (14:14-14:38)

```
[14:14] ListInstances, ListSecurityGroups, DescribeVpcs  
[14:19] CreatePolicyVersion -> Action: "iam:*", Resource: "*" applied to svc-terraform  
[14:22] CreateUser: "cloudops-recovery"  
[14:23] AddUserToGroup: cloudops-recovery -> Group: Administrators  
[14:38] CreateAccessKey for cloudops-recovery  
```

---

### Phase 3 - Exfiltration & Persistence (14:41-15:29)

```
[14:41-15:12] GetObject × 4,200 requests  
               Bucket: s3://company-patient-records-eu  
               Principal: cloudops-recovery  
               Total data transferred: ~18 GB  

[15:17] ModifyInstanceAttribute: EC2 i-0abc123  
        -> UserData updated (base64-encoded reverse shell script)  

[15:22] StopInstances + StartInstances: i-0abc123  
        (forces UserData to execute on reboot)  

[15:29] CloudTrail: StopLogging  
        Principal: cloudops-recovery  
```
