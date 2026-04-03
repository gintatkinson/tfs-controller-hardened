---
description: How to ensure 100% recovery and persistence for the TFS environment
---

# TeraFlowSDN ARM64 Persistence Protocol

This workflow ensures that the hardened TeraFlowSDN environment (ARM64) can be recovered to its "Source of Truth" baseline in the event of a system crash or disk corruption.

## 1. Using the Native Snapshot (Fastest)

The VM `tfs-vm-fresh` has a baseline snapshot: `hardened-v1`.

### To Restore from Snapshot:
If the VM becomes unstable, run:
```bash
multipass stop tfs-vm-fresh
multipass restore tfs-vm-fresh.hardened-v1
multipass start tfs-vm-fresh
```
This restores the entire VM, including the MicroK8s cluster, all hardened images, and the 9 core services, to their March 30th stable state.

## 2. Using the Recovery Script (Code-Level Restoration)

If the snapshot is unavailable but the repository is intact, use the `recovery.sh` script on the host:
```bash
chmod +x recovery.sh
./recovery.sh
```
This script sequentially re-deploys the 9 core services with the necessary ARM64 resource delays (180s probe delay) and fixed Ingress routing.

## 3. Mandatory Snapshot Maintenance

Whenever a new stable feature is merged into the "Source of Truth":
1. Verify all 9 core services are `1/1 Running`.
2. Stop the VM: `multipass stop tfs-vm-fresh`.
3. Take a new snapshot: `multipass snapshot tfs-vm-fresh --name v[NUMBER]`.
4. Restart: `multipass start tfs-vm-fresh`.

---
> [!IMPORTANT]
> The `hardened-v1` snapshot is your primary "Undo" button. Never modify core architecture (Dockerfiles/Manifests) without verifying the restoration path first.
