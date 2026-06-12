![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Flashrom

# Ubuntu VM

## In this lab we will
- Understand what firmware is and why it matters in security
- Explore **Flashrom** - a tool for reading and writing firmware chips
- Use the **dummy programmer** to safely simulate firmware read, write, erase, and verify operations without touching real hardware
- Learn what a real-world firmware attack or backup workflow looks like


---

## What is Flashrom?

**Flashrom** is an open-source tool that can read, write, erase, and verify firmware on flash chips. These chips hold your BIOS/UEFI, network card firmware, and other low-level software that runs before your operating system even loads.

In a real-world scenario, an attacker with physical or OS-level access could use Flashrom to:
- Dump a firmware image for offline analysis
- Flash a backdoored BIOS that survives OS reinstalls
- Bypass Secure Boot or tamper with boot integrity

As a defender or researcher, you would use it to:
- Back up the current firmware before changes
- Verify firmware has not been tampered with
- Restore a known-good firmware image



---

## Step 1 - Explore Available Programmers

A **programmer** is the interface Flashrom uses to talk to a flash chip. It could be:
- `internal` -> the chip on your actual motherboard (real hardware, requires root and correct chipset support)
- `dummy` -> a fake in-memory chip for safe testing
- `serprog` -> a serial protocol for external programmers like Arduino
- `linux_spi` -> SPI bus on a Raspberry Pi or similar board

List all supported programmers:

```bash
flashrom --help
```

<img width="824" height="133" alt="image" src="https://github.com/user-attachments/assets/89634a7b-8d7d-426d-88bd-8d66dc2da3df" />


You will see a long list after the **"-p" flag**. Today we will use `dummy`.

---

## Step 2 - Create a Dummy Flash Chip

The `dummy` programmer simulates a flash chip in RAM. You can pass parameters to define the chip size and type

Create a 1 MB blank flash image file to act as our "chip":

```bash
dd if=/dev/zero of=~/fake_firmware.bin bs=1M count=1
```

This creates a 1 MB file filled with zeros - simulating a blank erased chip

Confirm it was created:

```bash
ls -lh ~/fake_firmware.bin
```

<img width="789" height="160" alt="image" src="https://github.com/user-attachments/assets/a6bf2400-b4c7-4b79-a915-5ef0f2e16ba4" />


You should see a 1.0M file

---

## Step 3 - Write to the Dummy Chip

Now we will simulate flashing firmware onto our fake chip.

First, let's create a fake "firmware" file with some identifiable content:

```bash
echo "FIRMWARE_VERSION_1.0_BACKDOOR_FREE" > ~/my_firmware.bin
```

```bash
dd if=/dev/zero bs=1M count=1 >> ~/my_firmware.bin 2>/dev/null || true
truncate -s 4M ~/fake_firmware.bin
truncate -s 4M ~/my_firmware.bin
```

Now write it to the dummy chip:

```bash
flashrom -p dummy:emulate=SST25VF032B,image=/home/ubuntu/fake_firmware.bin -w ~/my_firmware.bin
```

Breaking down the command:
- `-p dummy:emulate=SST25VF032B` -> use the dummy programmer, emulating a real Winbond W25Q128 chip (a very common BIOS chip)
- `image=/home/ubuntu/fake_firmware.bin` -> the file on disk that acts as our chip storage
- `-w ~/my_firmware.bin` -> write this firmware to the chip

You will see output like:

<img width="1235" height="394" alt="image" src="https://github.com/user-attachments/assets/437e55fc-1c61-49f8-a3d3-5530392424e3" />


Flashrom always reads -> erases -> writes -> verifies. This is the standard safe workflow.

---

## Step 4 - Read Back the Firmware (Dump)

This is what an attacker or analyst would do first - dump the existing firmware for analysis.

```bash
flashrom -p dummy:emulate=SST25VF032B,image=/home/ubuntu/fake_firmware.bin -r ~/dumped_firmware.bin
```

- `-r` -> read from the chip and save to a file

Now inspect the dump:

```bash
strings ~/dumped_firmware.bin | head -20
```

You should see your firmware string in the output:

<img width="1263" height="393" alt="image" src="https://github.com/user-attachments/assets/f6cfd009-9193-4db2-8439-8bf7666d434f" />


This is exactly what a firmware analyst does - dump the chip, then run `strings`, `binwalk`, or `hexdump` on it to extract readable content and identify what is inside.

---

## Step 5 - Verify Integrity

A core defensive use of Flashrom is verifying that firmware has not been tampered with. Let's simulate this.

First, take a hash of the "known good" firmware:

```bash
sha256sum ~/my_firmware.bin
```

Save that hash somewhere (in a real scenario, you would store it in a secure, offline location).

Now verify the dumped firmware matches:

```bash
sha256sum ~/dumped_firmware.bin
```

Both hashes should match, confirming the chip contents are identical to what was written.

Now simulate tampering - modify the dump:

```bash
printf '\xDE\xAD\xBE\xEF' | dd of=~/dumped_firmware.bin bs=1 seek=100 conv=notrunc 2>/dev/null
```

Check the hash again:

```bash
sha256sum ~/dumped_firmware.bin
```

<img width="1207" height="161" alt="2026-06-12_20-23" src="https://github.com/user-attachments/assets/855c3564-a9de-478d-92b3-e171de630f71" />


The hash is now different. This is how firmware integrity checking works - if the hashes do not match, the firmware has been modified.

---

## Step 6 - Erase the Chip

Erasing sets every byte of the chip back to `0xFF` (the erased state of flash memory):

```bash
flashrom -p dummy:emulate=SST25VF032B,image=/home/ubuntu/fake_firmware.bin -E
```

- `-E` -> erase the entire chip

Flashrom will confirm:

```
Erasing and writing flash chip... Erase/write done.
```

Now dump it again and check:

```bash
flashrom -p dummy:emulate=SST25VF032B,image=/home/ubuntu/fake_firmware.bin -r ~/after_erase.bin
```

```bash
strings ~/after_erase.bin | head
```

<img width="1226" height="396" alt="image" src="https://github.com/user-attachments/assets/c08ea722-0a19-423b-9123-de807edd7bcc" />


No strings - the chip is blank. In a real attack scenario, an attacker erasing the BIOS chip would cause a complete system failure - it is essentially a destructive action.

---

## Step 7 - Restore from Backup

This is the defender workflow - restore a known-good firmware backup:

```bash
flashrom -p dummy:emulate=SST25VF032B,image=/home/ubuntu/fake_firmware.bin -w ~/my_firmware.bin
```

Then verify:

```bash
flashrom -p dummy:emulate=SST25VF032B,image=/home/ubuntu/fake_firmware.bin -v ~/my_firmware.bin
```

- `-v` -> verify only, do not write

Output:

```
Verifying flash... VERIFIED.
```

The firmware is restored and verified. This is exactly what incident responders do after detecting a firmware compromise.

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Firmware.md)

---

> Created by Turcu-Stiolica Alexandru
