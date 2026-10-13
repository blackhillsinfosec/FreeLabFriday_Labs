## Token from Local Storage

You are reviewing the source code of a web application. You notice the following JavaScript running on the login page after a successful authentication:

```javascript
localStorage.setItem("auth_token", response.token);
```

Later in the app, every API request is built like this:

```javascript
fetch("/api/profile", {
  headers: {
    "Authorization": "Bearer " + localStorage.getItem("auth_token")
  }
});
```

A separate finding in the same app shows it is vulnerable to stored XSS on the comments section.
