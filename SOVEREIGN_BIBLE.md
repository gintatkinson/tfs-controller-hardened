# CogCtrl Sovereign Bible (Hardened Technical Ledger)

This document is the absolute "Memory Anchor" for the Cognitive Controller (CogCtrl) project. It contains the verbatim technical ledger of every fix derived from previous failures.

---

## Part 1: Mandatory Succession Skills (Full Text)

### 1.1 Continuous Memory & Meta-Cognition Protocol
**Purpose**: Prevents context loss and infinite loops by enforcing "Documentation-First" action.
1. **Write Before You Bleed**: Append any missing dependency or rule to the skills matrix BEFORE scripting the fix.
2. **Decisions Require Plans**: Structural changes require an updated `implementation_plan.md` first.
3. **No Phantom Artifacts**: Distill all debugging efforts into KIs or Skills.
4. **Monitor Source of Truth**: Perform Rule 5 Reconciliation Audits (Active Document vs. Repo).

### 1.2 Linux Native Development (ARM64)
**Purpose**: Rules for case-sensitive, standalone environment stability.
1. **Direct VM Edits**: All code changes must happen inside the VM (Multipass exec).
2. **Standalone Mode**: Ignore all upstream ETSI branches once the mirror is founded.
3. **ARM64 Binary Law**: Use `grpc_health_probe-linux-arm64` (v0.4.18+).
4. **Prometheus Metric Safety**: Register metrics at call-time via `MetricsPool` to prevent duplicated timeseries.

---

## Part 2: The Hardened Technical Ledger

### 2.1 The Ingress /WebUI Correction
- **Failure**: Root-ingress redirects cause 404s and asset gaps.
- **Fix**: 
  - `manifests/webuiservice.yaml`: Ensure `path: /webui`.
  - `src/webui/service/__init__.py`: Add prefix middleware if pathing fails.

### 2.2 The Asset Resilience Patch
- **Failure**: `topology.js` location causing symlink "hacks".
- **Fix**: Move all files from `templates/js` to `static/js`. Update all templates to use `{{ url_for('static', filename='js/topology.js') }}`.

### 2.3 The Decorator.py ARM64 Stub
- **Failure**: `get_metrics_context` signature mismatch on ARM64 pod start.
- **Law**: Apply the following verbatim to `src/common/method_wrappers/Decorator.py`:
  ```python
  def get_metrics_context(service_name, method_name):
      # Compatibility stub for ARM64/Version divergence
      return MetricsContext(service_name, method_name)
  ```

### 2.4 The Kafka Service Discovery Hardening
- **Failure**: Services seeking `kafka-service` vs `kafka-public`.
- **Law**: Standardize all components to use the `KAFKA_SERVICE_HOST` environment variable.

---

## Part 3: Mandatory Workflows

### 3.1 The /hardened_build Sequence
1. **Pre-Flight Audit**: Check `src/pathcomp/backend/Makefile` for ARM64 `glib-2.0` paths.
2. **Persistence Audit**: Ensure `cockroachdb` manifests have Bound PVCs.
3. **User Approval**: Present the 13-screen audit checklist.
4. **Throttled Deploy**: Execute `deploy/all.sh` with 120s sleeps between components.

---

## Final Verification Checklist (The 13 Screens)
A deployment is only verified if the following screens load correctly:
1. Contexts, 2. Topologies, 3. Devices, 4. Links, 5. Services, 6. Slices, 7. Policies, 8. Monitoring, 9. L3-Attack, 10. Optical-Attack, 11. KPI-Management, 12. Load-Generator, 13. ZTP-Configuration.
