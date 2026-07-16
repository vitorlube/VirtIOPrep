# VirtIOPrep

Prepare Windows virtual machines for migration to Proxmox VE and other KVM-based hypervisors.

VirtIOPrep automatically detects the Windows version and installs the required Red Hat VirtIO drivers into the Windows Driver Store, allowing the VM to boot after changing the virtual storage controller.

---

## Features

- Automatic Windows version detection
- Installs the correct VirtIO drivers
- Supports:
  - Balloon
  - NetKVM
  - QEMU PCI Serial
  - VirtIO SCSI
  - VirtIO Block (viostor)
- Offline installation
- No VMware Tools modifications
- No reboot required before migration (recommended afterwards)

---

## Supported Operating Systems

- Windows Server 2016
- Windows Server 2019
- Windows Server 2022
- Windows 10 x64
- Windows 11 x64

---

## Usage

Run PowerShell as Administrator.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\VirtIOPrep.ps1
```

---

## Example

```
==============================================
              VirtIOPrep v1.0
==============================================

Detected OS : Windows Server 2022

Installing Balloon...
OK

Installing NetKVM...
OK

Installing QEMU PCI Serial...
OK

Installing VirtIO SCSI...
OK

Installing VirtIO Block...
OK

VirtIO drivers successfully staged.

A reboot is recommended before migrating the VM.
```

---

## What it does

VirtIOPrep stages the required VirtIO drivers in the Windows Driver Store before migration.

It does **not** migrate the virtual machine.

Migration can be performed using:

- Veeam Backup & Replication
- Proxmox Backup Server
- Disk conversion
- Manual migration
- Any VMware → Proxmox workflow

---

## Why?

Migrating a Windows VM directly from VMware to VirtIO storage usually results in:

```
INACCESSIBLE_BOOT_DEVICE
```

VirtIOPrep prevents this by installing the required drivers before the migration.

---

## Project Structure

```
VirtIOPrep
│
├── VirtIOPrep.ps1
└── drivers
    ├── Balloon
    ├── NetKVM
    ├── qemupciserial
    ├── vioscsi
    └── viostor
```

---

## License

MIT License

---

## Disclaimer

VirtIO drivers are developed and distributed by Red Hat.

This project only automates their installation and is not affiliated with Red Hat, VMware or Proxmox.
