![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

[Part1](/Cards/DET/labs/volatilityLab1.md)   [Part2](/Cards/DET/labs/volatilityLab2.md)   [Part3](/Cards/DET/labs/volatilityLab3.md)   [Part4](/Cards/DET/labs/volatilityLab4.md)

This is the 1st of 4 parts

## Start

In this lab you will be given 4 different linux memory dumps located in ``~/labs/volatility3``, they all have malware inside and your task is to find where is the malware and which process it is, we will be using **$IMG** for the dump path and file, and **$SYMS** for the remote ISF URL

# Setup

```bash
IMG=~/labs/volatility3/stage1.lime
```
```bash
SYMS='--remote-isf-url https://github.com/Abyss-W4tcher/volatility3-symbols/raw/master/banners/banners.json'
```

The commands will be in this template:
```bash
python3 vol.py -f "$IMG" $SYMS linux.something
```

## Your turn
Try to find the malware using the commands in the [Volatility Documentation](/courseFiles/tools/Volatility.md) and then scroll down to see what you should've looked for

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

Stage 1 is all about a obvious process called ``evilminerd`` running visibly in the system

<img width="1174" height="65" alt="image" src="https://github.com/user-attachments/assets/0197ede6-fc02-4c37-ba04-daa4837b6cf8" />

You can detect it using ``linux.pslist.PsList``, the name standing out immediately

**Notes** 

Obvious malware is often trivial to spot

Basic **process enumeration** is key to and usually the first step to any memdump analysis

---
[Back to the Card](/Cards/DET/Memory_Analysis.md)
