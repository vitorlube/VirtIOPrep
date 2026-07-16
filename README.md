# VirtIOPrep

Prepare Windows virtual machines for seamless VMware → Proxmox migration by preloading VirtIO drivers.

VirtIOPrep automatically detects the operating system, installs the required VirtIO drivers into the Windows Driver Store, validates the installation, and prepares the VM for migration.

---

## Supported Operating Systems

- Windows Server 2016 x64
- Windows Server 2019 x64
- Windows Server 2022 x64
- Windows Server 2025 x64
- Windows 10 x64
- Windows 11 x64

---

## Included Drivers

- Balloon
- NetKVM
- VirtIO SCSI
- VirtIO Block
- QEMU PCI Serial

---

## Features

- Automatic OS detection
- Automatic driver selection
- No VirtIO ISO required
- No manual driver installation
- No DISM commands
- No Device Manager interaction
- Automatic validation
- One-command installation
- Optimized for VMware → Proxmox migrations

---

# Quick Start

Open **PowerShell as Administrator**.

If PowerShell blocks script execution, allow scripts for the current session only:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

Then run:

```powershell
irm https://raw.githubusercontent.com/vitorlube/VirtIOPrep/main/install.ps1 | iex
```

That's it.

The installer will automatically:

- Download the latest VirtIOPrep release
- Download the required VirtIO driver package
- Extract the files
- Install the drivers into the Windows Driver Store
- Validate the installation
- Remove temporary files

---

## Typical Migration Workflow

1. Run VirtIOPrep inside the VMware virtual machine.
2. Wait for the installation to complete.
3. Shut down the virtual machine.
4. Restore or migrate the VM to Proxmox using VirtIO controllers.
5. Power on the VM.

Windows will automatically detect the VirtIO devices during the first boot.

---

## Project Structure

```
VirtIOPrep
├── install.ps1
├── VirtIOPrep.ps1
└── drivers.zip
```

---

## Notes

- Administrator privileges are required.
- Internet access is required during installation.
- VirtIOPrep installs the drivers into the Windows Driver Store so they are available after migration.
- No reboot is required before shutting down and migrating the VM.

---

## License

MIT License
