## Full Network Takeover via DHCPv6

You are a senior analyst responding to an incident. An endpoint detection tool flagged unusual outbound traffic from multiple workstations to an internal IP that isn't in your asset registry. You begin pulling data.

**UEBA alert:**
```
Anomaly detected: 14 workstations authenticating to unknown host 192.168.1.99
Timeframe: 08:45 – 09:10
User accounts involved: 14 distinct domain accounts
```

**DHCPv6 traffic log (08:44):**
```
08:44:12  ff02::1:2  (multicast)   DHCPv6   SOLICIT from fe80::aabb:ccdd
08:44:12  192.168.1.99             DHCPv6   ADVERTISE — DNS server: fe80::aabb:ccdd
08:44:13  <all 14 workstations>    DHCPv6   REQUEST → accepted
```

**DNS query log (08:45 onward):**
```
workstation-01 → fe80::aabb:ccdd  DNS  query: dc01.corp.local
fe80::aabb:ccdd → workstation-01  DNS  response: 192.168.1.99

workstation-02 → fe80::aabb:ccdd  DNS  query: dc01.corp.local  
fe80::aabb:ccdd → workstation-02  DNS  response: 192.168.1.99
[... repeated for all 14 workstations ...]
```

**NetFlow data (08:45 – 09:10):**
```
All 14 workstations → 192.168.1.99   SMB/LDAP   Authentication attempts
192.168.1.99 → dc01.corp.local       LDAP       Forwarded authentication sessions
```

Your environment has no IPv6 infrastructure. There is no legitimate DHCPv6 server on the network.
