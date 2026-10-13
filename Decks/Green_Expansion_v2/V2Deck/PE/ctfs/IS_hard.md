## Full Campaign Reconstruction

Your team has been called in after an incident. You are given logs from a 72-hour window. Piece together what happened.

**Cloud event logs show:**

```
DAY 1 - 23:41 - Account ceo-assistant@company.internal authenticated from IP 94.102.49.190
DAY 1 - 23:43 - Search query executed in mailbox: "wire transfer", "approval", "finance"
DAY 1 - 23:51 - 3 emails read (CFO thread regarding pending $240,000 vendor payment)
DAY 2 - 00:03 - No further activity
```

**DAY 2 - 09:02** - CFO receives an email from `ceo-assistant@company.internal`:

```
Subject: Re: Vendor Payment - Urgent Update

Marcus,

The CEO asked me to let you know the wire details changed - please use the new
account below for today's transfer. He is in meetings all morning and unreachable.

Account: DE89 3704 0044 0532 0130 00
```

**UEBA alert - DAY 2 09:03:**

```
ANOMALY - ceo-assistant@company.internal
Baseline: avg 2 emails/day, all internal, business hours only
Observed: email sent 09:02, external bank reference, deviation score 94/100
```

**DAY 2 - 09:45** - CFO confirms the transfer was approved and processed.

**DAY 2 - 14:30** - CEO returns from meetings. No record of him requesting any payment change.