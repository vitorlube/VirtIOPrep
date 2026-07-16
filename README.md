# VirtIOPrep

Prepare Windows virtual machines for seamless migration from VMware, Hyper-V or other hypervisors to KVM-based platforms such as Proxmox VE.

VirtIOPrep preloads the required Red Hat VirtIO drivers into the Windows Driver Store before migration, preventing common boot failures such as **INACCESSIBLE_BOOT_DEVICE** after changing the storage controller.

---

## Features

- Detects Windows version automatically
- Installs the correct VirtIO drivers
- Supports:

  - Balloon
  - NetKVM
  - QEMU Serial
  - VirtIO SCSI
  - VirtIO Block (viostor)

- Offline driver package
- No internet required
- Single PowerShell command
- Windows Server 2016+
- Windows 10 / 11

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
