## Hidden Data in Traffic

You are analyzing network captures from a web server that was recently compromised.

Most traffic looks normal, but you notice a series of requests like this:

```
GET /track?id=6d795f646174615f7061727431 HTTP/1.1
GET /track?id=6d795f646174615f7061727432 HTTP/1.1
GET /track?id=6d795f646174615f7061727433 HTTP/1.1
```

The destination domain is unknown and not part of the company's infrastructure.
