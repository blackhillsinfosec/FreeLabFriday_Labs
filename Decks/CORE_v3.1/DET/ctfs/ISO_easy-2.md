## Firewall Rule Reconstruction

You are reviewing firewall rules on a compromised Linux host that was isolated at the host level. A colleague ran the following commands during the incident:

```
iptables -I INPUT -j DROP
iptables -I OUTPUT -j DROP
iptables -I INPUT -s 10.0.0.5 -j ACCEPT
iptables -I OUTPUT -d 10.0.0.5 -j ACCEPT
```

`10.0.0.5` is the IP address of your SOC management server.
