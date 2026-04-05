---
name: CogCtrl Succession Skill (Portable Agent Instructions)
description: Mandatory agent directive to ensure that the millions of failures encountered in previous iterations are never repeated.
---

# CogCtrl Succession Skill

This skill is mandatory for any AI or human interacting with the CogCtrl project. It ensures that the absolute "Memory Anchor" is preserved across resets.

## 1. Primary Directives

### Mandatory Documentation-First Workflow
- **Rule**: If a bug is encountered or a dependency is missing, you MUST first update this skill file or the `SOVEREIGN_BIBLE.md` before applying the fix.
- **Goal**: Prevent the loss of "Wisdom" across session reloads or repository resets.

### Zero-Anchor "Ground Zero" Reset
- **Rule**: If the system's "Source of Truth" is compromised, do not attempt to "stabilize" it. WIPE the workspace and the VM, and rebuild from the official ETSI snapshot as defined in the `bootstrap_hardened.sh`.

## 2. Mandatory Technical Constraints (ARM64)

### Binary Consistency
- **Rule**: Every `Dockerfile` must use `grpc_health_probe-linux-arm64` (v0.4.18+).
- **Rule**: Images MUST be built locally (`localhost:32000`) for the target architecture.

### Service Rollout Discipline (Throttled)
- **Rule**: Rolling out more than one large service (e.g., `deviceservice`, `pathcompservice`) at a time is FORBIDDEN.
- **Rule**: Enforce a 120-second mandatory cooldown between service starts to prevent gRPC handshake timeouts.

### Prometheus & Liveness Safety
- **Rule**: Metrics registration MUST use a `MetricsPool` to prevent `ValueError: Duplicated timeseries` on pod restarts.
- **Rule**: Liveness and readiness probes must have `initialDelaySeconds: 180` and `failureThreshold: 30` to account for startup latency.

## 3. WebUI Integrity

### Pathing & Assets
- **Rule**: The WebUI MUST be served via the `/webui` prefix.
- **Rule**: All templates MUST reference assets via `url_for('static', ...)` to avoid pathing errors.

## 4. Verification Baseline

A deployment is ONLY successful when:
1. **Atomic Transaction**: Data is loaded via CLI and verified via WebUI.
2. **Resource Buffer**: Every service has >20% resource headroom.
3. **13-Screen Audit**: All 13 WebUI modules load correctly (Contexts, Topologies, Devices, Links, Services, Slices, Policies, Monitoring, L3-Attack, Optical-Attack, KPI-Mgmt, Load-Gen, ZTP).
