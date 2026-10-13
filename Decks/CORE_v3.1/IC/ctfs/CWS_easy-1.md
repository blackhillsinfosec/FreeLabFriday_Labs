![image](/FilesForLabs/images/blueantisyphon.png)

## Simple Web Exploit

A small company hosts a login page for internal staff. During testing, you notice that the login form behaves strangely when special characters are used.

Your goal is to identify what type of vulnerability is present.

---

## Observation

When entering:

`' OR '1'='1`

the application logs you in without valid credentials.
