# Zeek Lab - Investigating a malicious pcap

---

## Objectives

- Run Zeek over [this pcap](./lab_interlock.pcap) and inspect Zeek logs.
- Extract DNS, HTTP and TLS indicators with `zeek-cut`.
- Identify suspicious HTTP POSTs and TLS SNI values.
- Implement a tiny Zeek detection script that raises Notices for known malicious domains.

---

## Setup

Run Zeek on the pcap to generate Zeek logs in the current directory. The logs (dns.log, http.log, ssl.log) are the data sources for the lab.

```bash
cd /home/ubuntu/SOC_Analyst_Labs/zeek
```

```bash
mkdir -p zeek-out && cd zeek-out
```

```bash
zeek -r ../lab_interlock.pcap
```

```bash
ls -1
```
<img width="900" height="468" alt="image" src="https://github.com/user-attachments/assets/c055837e-1096-49d4-ba39-e036b5d0c864" />



---

## Task 1 - inspect core logs

Get a quick view of DNS queries, sample HTTP entries, and sample TLS SNI values if present.

```bash
zeek-cut id.orig_h query rcode_name < dns.log | head -n 10
zeek-cut ts id.orig_h host method uri status_code < http.log | head -n 15
ls tls.log ssl.log 2>/dev/null || true
[ -f tls.log ] && zeek-cut ts id.orig_h id.resp_h server_name < tls.log | head
[ -f ssl.log ] && zeek-cut ts id.orig_h id.resp_h server_name < ssl.log | head
```

---

## Task 2 - find suspicious HTTP POSTs

Extract HTTP requests where the method is POST; these often indicate data exfiltration or C2 beacons.

```bash
zeek-cut ts id.orig_h host method uri status_code < http.log | awk '$4=="POST"{print $0}' | sort -u
```

<img width="1741" height="1063" alt="image" src="https://github.com/user-attachments/assets/c5fe66bd-eba1-42f2-8245-b2cfd98072e0" />


---

## Task 3 - inspect TLS SNI for landing pages

List unique TLS server\_name (SNI) values to find hostnames used as landing pages or C2 endpoints.

```bash
if [ -f tls.log ]; then
  zeek-cut ts id.orig_h id.resp_h server_name < tls.log | sort -u | head
elif [ -f ssl.log ]; then
  zeek-cut ts id.orig_h id.resp_h server_name < ssl.log | sort -u | head
else
  echo "No TLS log found"
fi
```
<img width="916" height="402" alt="image" src="https://github.com/user-attachments/assets/34eed943-c251-4132-9282-b811963ba1e1" />


---

## Task 4 - build a CSV of suspicious events

Export HTTP and TLS events into a simple CSV for easy review and reporting.

```bash
(zeek-cut host < http.log 2>/dev/null || true) | sort -u
```
<img width="1152" height="254" alt="image" src="https://github.com/user-attachments/assets/d3a1498e-4fcd-492c-935f-9132a007e41f" />

```bash
(zeek-cut server_name < ssl.log 2>/dev/null || true) | sort -u
```
<img width="1197" height="1082" alt="image" src="https://github.com/user-attachments/assets/14a25964-589f-4ab7-9880-e5413eb6f4d4" />

```bash
zeek-cut ts id.orig_h host method uri status_code < http.log 2>/dev/null | awk -F"\t" 'NR>1{print $1","$2","$3",http"}' > http_events.csv
```
<img width="802" height="49" alt="image" src="https://github.com/user-attachments/assets/1f4a962d-42b6-447f-ae4e-423c08bfbf15" />

```bash
if [ -f ssl.log ]; then
  zeek-cut ts id.orig_h id.resp_h server_name <ssl.log | awk -F"\t" 'NR>1{print $1","$2","$3",tls"}' > tls_events.csv
fi
```
<img width="1832" height="575" alt="image" src="https://github.com/user-attachments/assets/690fe795-3185-4adf-a9b5-d08818d8d732" />

```bash
( echo "ts,client,domain,proto"; cat http_events.csv tls_events.csv 2>/dev/null ) > suspicious_events.csv
```
<img width="901" height="687" alt="image" src="https://github.com/user-attachments/assets/70dbcc0c-ad6a-4903-8fa1-d6e7a6da6490" />

```bash
head -n 20 suspicious_events.csv
```
<img width="903" height="491" alt="image" src="https://github.com/user-attachments/assets/5df2fead-1488-4408-9c42-53fa3f1feb44" />


---

## Task 5 - Zeek detection script 

Raise a Notice when HTTP Host or TLS SNI matches a small set of known malicious domains.

**High-level idea:**
- Load HTTP, TLS, and Notice frameworks.
- Keep a list of suspicious domains.
- Watch HTTP host headers and TLS SNI fields for matches.
- Log a Notice when a match is found.

### Script

- Run this command to create this script and to save it as `mal_domains.zeek`

```bash
cat <<'EOF' > mal_domains.zeek
@load base/protocols/http
@load base/protocols/ssl
@load base/frameworks/notice

redef enum Notice::Type += { Suspicious_Domain };

const Suspicious_Domains: set[string] = {
    "windows-msgas.com",
    "eventdata-microsoft.live",
    "event-datamicrosoft.live",
    "event-time-microsoft.org",
    "varying-rentals-calgary-predict.trycloudflare.com",
    "www.truglomedspa.com"
};

function maybe_notice_domain(c: connection, domain: string, proto: string)
{
    if ( domain in Suspicious_Domains )
    {
        NOTICE([
            $note = Suspicious_Domain,
            $msg  = fmt("%s to suspicious domain: %s", proto, domain),
            $conn = c,
            $identifier = fmt("%s/%s/%s", proto, domain, c$id$orig_h)
        ]);
    }
}

event http_request(c: connection, method: string, original_URI: string, unescaped_URI: string, uri: string)
{
    if ( c?$http && c$http?$host )
        maybe_notice_domain(c, c$http$host, "http");
}

event ssl_extension_server_name(c: connection, is_orig: bool, names: string_vec)
{
    if ( is_orig )
    {
        for ( i in names )
        {
            local sni = names[i];
            maybe_notice_domain(c, sni, "tls");
        }
    }
}
EOF
```



## Run the detection script and inspect results

Run Zeek with the script to generate notice.log entries for matches.

```bash
zeek -r ../lab_interlock.pcap mal_domains.zeek
```

```bash
cat notice.log
```
<img width="1839" height="335" alt="image" src="https://github.com/user-attachments/assets/c7cea381-9491-4c19-8afa-d1a74fcf4bd4" />


---

## Useful review commands

Count frequent NXDOMAIN responses to find noisy/misconfigured names; page through HTTP POSTs for manual review.

```bash
zeek-cut id.orig_h query rcode_name < dns.log | awk '$3=="NXDOMAIN" {print $2}' | sort | uniq -c | sort -rn | head
```

```bash
zeek-cut ts id.orig_h host method uri status_code < http.log | awk '$4=="POST"{print $0}' | sort -u | less
```

<img width="1839" height="91" alt="image" src="https://github.com/user-attachments/assets/e69b8b1e-b644-4871-a939-0c171aa4075b" />

<img width="1839" height="1082" alt="image" src="https://github.com/user-attachments/assets/d41d2ef1-ddeb-4229-91b3-7a013e869248" />


---

Check out  [Zeek Lab Results](./zeek_lab_results.md) for a better understaning.

---
[Back to the section](/courseFiles/Section_05-networkingAndTelemetry/networkingAndTelemetry.md)
