![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious Connection Hunt

You are reviewing firewall logs after users reported slow network performance.

You notice the same external IP contacting many internal hosts within a short period:

```
2024-06-10 10:14:02 ALLOW SRC=203.0.113.45 DST=10.0.0.12 DPT=22
2024-06-10 10:14:05 ALLOW SRC=203.0.113.45 DST=10.0.0.18 DPT=22
2024-06-10 10:14:08 ALLOW SRC=203.0.113.45 DST=10.0.0.23 DPT=22
2024-06-10 10:14:11 ALLOW SRC=203.0.113.45 DST=10.0.0.31 DPT=22
```
