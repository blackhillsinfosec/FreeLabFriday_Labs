## Lateral Movement Detection

During an investigation, you review firewall logs from an internal segment.

You notice this sequence:

```
2024-06-10 13:20:11 ALLOW SRC=10.0.1.15 DST=10.0.2.21 DPT=445
2024-06-10 13:20:19 ALLOW SRC=10.0.1.15 DST=10.0.2.34 DPT=445
2024-06-10 13:20:26 ALLOW SRC=10.0.1.15 DST=10.0.2.56 DPT=445
2024-06-10 13:20:30 ALLOW SRC=10.0.1.15 DST=10.0.2.77 DPT=445
```

The source host normally only communicates with a file server.
