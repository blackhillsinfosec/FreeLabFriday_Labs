## OAuth Token Abuse

A company uses OAuth 2.0 to allow a third-party reporting tool to access employee data. During a security review, you capture the following authorization request being sent to the OAuth server:

```
GET /oauth/authorize
  ?response_type=code
  &client_id=reporting-tool
  &redirect_uri=https://reporting.internal/callback
  &scope=read:all
  &state=abc123
```

The OAuth server responds with a code, which the reporting tool then exchanges for an access token. You also notice the following:

- The `redirect_uri` parameter is not validated server-side
- The `scope=read:all` grants access to every employee record
- The access token has no expiry set and is logged in plaintext in the app's debug logs
