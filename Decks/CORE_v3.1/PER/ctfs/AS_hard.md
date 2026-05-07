![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Defense Evasion Scenario

During incident response, you observe:

-   A suspicious `.sdb` file in `C:\Windows\AppPatch\Custom\`
-   Registry entries pointing to the file
-   An endpoint detection tool failing to detect a known malicious executable
-   No signs of tampering in the detection tool's configuration

---

## Question

What is the most accurate explanation?

---

## Flags (Choose One)

-   **A)** The detection tool is corrupted
-   **B)** The malicious file deleted itself
-   **C)** Application shimming is intercepting API calls to hide malicious activity
-   **D)** The system clock was modified

---

Correct Flag: **C**

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Application_Shimming.md)
