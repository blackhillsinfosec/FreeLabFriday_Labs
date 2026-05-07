![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Trust Issues

You are reviewing a SIEM alert. The alert was triggered when a user account from **Domain A** authenticated against a resource in **Domain B**. The two domains have a trust relationship configured.

The account in question belongs to a help desk technician in Domain A. It has never accessed Domain B before. The authentication happened at 2:47 AM on a Saturday.

There are no open tickets or change requests for that night.

---

## Question

What should this activity be treated as?

---

## Flags (Choose One)

- **A)** Normal behavior - domain trusts are designed for this
- **B)** A scheduled sync task running as expected
- **C)** A misconfigured GPO pushing settings to Domain B
- **D)** A potentially compromised account abusing a domain trust relationship

---

Correct Flag: **D**

---

# Finished?
[Next Question](WAD_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Weaponizing_Active_Directory.md)
