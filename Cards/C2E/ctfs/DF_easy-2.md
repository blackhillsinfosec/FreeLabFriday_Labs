![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Log Analysis Basics

You are reviewing firewall logs after a threat hunting alert fired. One workstation stands out. Here is a snippet of its outbound traffic over a 10-minute window:

```
10:00:00  HTTPS  104.21.x.x (Cloudflare)  200 OK  430 bytes
10:00:30  HTTPS  104.21.x.x (Cloudflare)  200 OK  428 bytes
10:01:00  HTTPS  104.21.x.x (Cloudflare)  200 OK  431 bytes
10:01:30  HTTPS  104.21.x.x (Cloudflare)  200 OK  429 bytes
10:02:00  HTTPS  104.21.x.x (Cloudflare)  200 OK  430 bytes
```

The user-agent on every request matches Chrome 124. No browser window was open at the time.

---

## Question

What is the most suspicious indicator in these logs?

---

## Flags (Choose One)

- **A)** The destination IP belongs to Cloudflare, which is inherently suspicious
- **B)** HTTPS traffic should not be visible in firewall logs at all
- **C)** The requests fire at a perfectly consistent 30-second interval with no user interaction
- **D)** The response size is too small to be a real web page

---

Correct Flag: **C**

---

# Finished?

[Next Question](DF_medium.md)  
[Back to Card's Main Page](../Domain_Fronting_As_C2.md)
