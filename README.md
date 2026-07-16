# VirtIOPrep
Prepare Windows virtual machines for seamless migration from VMware to VirtIO-based hypervisors such as Proxmox VE.

VirtIOPrep preloads the official Red Hat VirtIO drivers into Windows without removing VMware Tools or modifying the current hypervisor configuration.

This allows Windows to boot immediately after migration to Proxmox without entering recovery mode due to missing storage or network drivers.

## Features

- Preserves VMware Tools
- Installs official Red Hat VirtIO drivers
- Supports Windows Server and Windows 10/11
- Designed for VMware → Proxmox migrations
- One-command execution

## Planned usage

```powershell
irm https://raw.githubusercontent.com/vitorlube/VirtIOPrep/main/install.ps1 | iex
```

## Status

🚧 Early development
