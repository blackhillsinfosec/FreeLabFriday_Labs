![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Surveillance Gap Analysis

A reviewer is mapping camera coverage across a three-floor office building. They produce the following notes:

```
Floor 1 - Main lobby:        COVERED
Floor 1 - Reception desk:    COVERED
Floor 1 - Side entrance:     NO CAMERA
Floor 1 - Loading dock:      NO CAMERA
Floor 2 - Open office:       COVERED
Floor 2 - Server room door:  COVERED
Floor 3 - Executive suite:   COVERED
Floor 3 - Stairwell exit:    NO CAMERA
```

The building has one security guard posted at the front lobby desk from 08:00 to 20:00. Outside those hours, access relies entirely on cameras and badge logs.

---

## Question

An attacker wants to enter the building after hours without being recorded. Based on the camera map, which entry point gives them the best chance?

---

## Flags (Choose One)

- **A)** The main lobby, because the guard is not present after 20:00
- **B)** The loading dock on Floor 1, which has no camera coverage
- **C)** The server room door on Floor 2, because it is the highest-value target
- **D)** The executive suite on Floor 3, because it is the least used area

---

Correct Flag: **B**

---

# Finished?

[Next Question](PSR_medium.md)

[Back to Card's Main Page](../Physical_Security_Review.md)
