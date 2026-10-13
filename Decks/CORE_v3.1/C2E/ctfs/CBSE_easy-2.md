## API Key in the Logs

You are analyzing firewall logs after a security alert. You find a series of outbound HTTPS requests from a workstation that belongs to an intern who left the company two weeks ago.

```
[14:05:11] SRC: 192.168.1.74  DST: api.dropboxapi.com:443  BYTES_OUT: 512
[14:05:44] SRC: 192.168.1.74  DST: api.dropboxapi.com:443  BYTES_OUT: 512
[14:06:17] SRC: 192.168.1.74  DST: api.dropboxapi.com:443  BYTES_OUT: 512
[14:06:50] SRC: 192.168.1.74  DST: api.dropboxapi.com:443  BYTES_OUT: 512
```

The requests repeat every 33 seconds, consistently, for 4 hours straight. The total data sent is roughly 140 MB. The machine has no Dropbox client installed.
