---
description: How to ensure 100% recovery and persistence for the TFS environment
---

To ensure the platform is fully functional after a hard restart, follow this checklist:

### 1. Infrastructure Persistence
- [ ] **Verify Database Storage**: Check if `cockroachdb` has a Bound PersistentVolumeClaim (PVC).
  ```bash
  kubectl get pvc -n crdb
  ```
  If missing, re-apply the manifest with a `volumeClaimTemplates` or manual PVC.
- [ ] **Verify Network Stability**: Ensure the static IP `10.0.2.10` is in `/etc/netplan/` and not just applied via `ip addr`.
- [ ] **Verify Registry Presence**: Ensure the local container registry is persistent and contains the ARM64 images.

### 2. Application Architecture
- [ ] **ARM64 Compatibility**: For every microservice in `CrashLoopBackOff`, verify the image architecture matches the VM (ARM64).
- [ ] **Build Check**: If an image is X86_64, use the local build workflow to recreate it for ARM64.

### 3. Data Consistency
- [ ] **Re-inject State**: After a restart, verify the `admin` context exists.
  ```python
  python3 verify_data.py
  ```
- [ ] **Auto-population**: If missing, automatically run the `load_descriptors.py` script.

### 4. Verification
- [ ] **WebUI Health**: Check if `webuiservice` can reach `contextservice`.
- [ ] **Functional Test**: Access `http://10.0.2.10/webui/` and verify the device list is populated.
