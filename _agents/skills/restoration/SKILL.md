---
name: TeraFlowSDN Restoration & Recovery
description: Mandatory procedures and health checks for restoring the TeraFlowSDN environment and recovering from faults or restarts.
---

# TeraFlowSDN Restoration and Recovery

This skill defines the standard operating procedures for recovering and verifying the TeraFlowSDN (TFS) environment on the ARM64 VM. It must be consulted whenever the system experiences a crash, restart, or requires a clean-slate rebuild.

## 1. Zero-Hacks Policy
When restoring the system, you must NOT use temporary workarounds. Every deployment MUST verify compliance with the following remediation requirements from `RESTORATION_AUDIT.md`:
- **WebUI Ingress**: Restore the `/webui` prefix in the Ingress manifests and ensure Flask middleware handles it correctly. No root-redirect hacks.
- **WebUI Assets**: Eliminate the `templates/js -> static/js` symlink. All Javascript must reside in `static/js/` and use `url_for('static', filename='js/...')` in templates.
- **DeviceService Decorator**: Apply compatibility stubs to `src/common/method_wrappers/Decorator.py` (specifically `MemoryPool` and `get_metrics_context`) to allow the `deviceservice` to run natively from `localhost:32000/tfs/device:dev`.
- **Service Discovery**: Replace hardcoded database hostnames with standard environment variables (`CRDB_SERVICE_HOST`, `QDB_SERVICE_HOST`).

## 2. Recovery Checklist
When assessing a recovered or freshly built system, you MUST perform these checks before declaring the system stable:

### A. Environment Access
Verify that `microk8s` can be executed by the `ubuntu` user without `sudo`. If not, fix the permissions:
```bash
sudo usermod -aG microk8s ubuntu
sudo chown -R ubuntu ~/.kube
# When running commands via multipass exec, use:
# sg microk8s -c "microk8s kubectl get pods -A"
```

### B. Pod and Image Health
- All pods in the `tfs` namespace must be completely `Running` or `Completed`.
- If pods exhibit `ImagePullBackOff`, investigate the local container registry (`localhost:32000`) and the ARM64 image build process. Do NOT ignore this state.

### C. Persistent Storage
- Verify that stateful components (CockroachDB, QuestDB, NATS, Kafka) have **Bound** `PersistentVolumeClaim` (PVC) resources.
- If PVCs are missing, the system is not resilient to reboots and the deployment configurations must be audited. Refer to the `/ensure_persistence` workflow.

## 3. The "Success Baseline" Validation
A restoration is ONLY complete when the system passes the **UI-Level Validation**:
1. The **Data Bootstrap** (e.g., loading `ofc22` descriptors) has been successfully executed.
2. All 13 WebUI menu screens have been visually verified to load without errors.
3. The system can survive a `multipass stop --force` and `multipass start` cycle with all data intact.
