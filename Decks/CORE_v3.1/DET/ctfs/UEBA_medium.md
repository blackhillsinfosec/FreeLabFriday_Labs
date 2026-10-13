## Insider Threat Investigation

Your UEBA platform has flagged **dan.Constantin**, a developer who gave his two-week notice last Monday.

His baseline over the past year:

- Accesses only his team's GitLab repos and the dev database
- Average daily data transfer: **~50 MB**
- No access to HR, finance, or client contract systems

UEBA risk score jumped from **12 -> 87** over three days. Here is the timeline:

```
Day 1 - Tuesday
09:14  Accessed /shared/contracts/ (first time ever)
09:31  Accessed /shared/finance/invoices_2023.xlsx
10:05  Searched internal wiki for "NDA template"

Day 2 - Wednesday
08:50  Connected personal USB device (flagged by endpoint agent)
11:20  Bulk downloaded 3.2 GB from GitLab - all repos, including ones outside his team
14:40  Sent email with attachment to personal Gmail (blocked by DLP)

Day 3 - Thursday
08:30  Login from home VPN - normal
08:35  Attempted access to HR performance review system - denied
09:10  Compressed folder: project_archive_final.zip (2.1 GB)
09:45  Uploaded to personal Google Drive (not blocked - cloud policy gap)
```
