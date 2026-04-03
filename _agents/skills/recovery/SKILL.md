---
name: Universal Recovery & Bootstrap Protocol
description: The absolute 'Source of Truth' for re-establishing the TFS environment from a blank-slate OS.
---

# Universal Recovery & Bootstrap Protocol

## Overview
This skill is the **Memory Anchor**. It ensures that if the local OS, VMs, and credentials are wiped, the 'Antigravity ID' can always reconstruct the environment using only the repository as a starting point.

## Mandatory Restoration Workflow

### 1. The Bootstrap Command
Upon entering a fresh session, if the environment is not 'In-Sync' (e.g., VMs are missing or DMG is unmounted), I MUST run the bootstrap script:
```bash
./bootstrap.sh
```

### 2. Environment Dependencies
- **Multipass**: Required for the Linux environment.
- **TFS_MIRROR DMG**: Required for case-sensitive filesystem integrity.
- **Git**: Required for the 'Source of Truth'.

### 3. Recovery Procedure (Idempotent)
1. **Repository Check**: Verify that `controller-develop/` exists and is on the `main` branch (or latest hardened tag).
2. **DMG Mounting**: Use `hdiutil attach` using a relative path to the DMG.
3. **VM Initialization**: Start `tfs-vm-fresh` (Ubuntu 24.04).
4. **Internal Recovery**: Execute `/home/ubuntu/tfs-main/recovery.sh` inside the VM.

## Hardening Points
- **Zero Absolute Paths**: All scripts MUST use `$HOME` or relative repo paths. No `/Users/perkunas/...`.
- **Documentation-First**: No architectural changes or bug fixes are to be made without first updating the in-repo `_agents/skills/`.
