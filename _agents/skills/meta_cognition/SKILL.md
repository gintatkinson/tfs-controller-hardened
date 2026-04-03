---
name: Continuous Memory & Meta-Cognition Protocol
description: Mandatory agent directive enforcing 'Documentation-First' workflows to prevent context loss across long or truncated sessions.
---

# Continuous Memory & Meta-Cognition Protocol

## Overview
Because agent contexts are ephemeral and truncate over long sessions, any undocumented host dependencies, architectural decisions, or deployment workarounds are inevitably forgotten, leading to infinite loops and redundant debugging. This skill establishes the absolute law of **Documentation-First Action**.

## Mandatory Rules (The Agent's Prime Directives)

1. **Write Before You Bleed**:
   - If you encounter a compilation error due to a missing package (e.g., C++ `build-essential`, `make`, `gcc`), DO NOT just blindly script its installation. 
   - **First**, open the relevant `_agents/skills/` file (e.g., `linux_native/SKILL.md` or `restoration/SKILL.md`) and permanently append the dependency to the matrix.

2. **Decisions Require Plans**:
   - If a script requires a structural modification (e.g., altering a database from `cluster` to `single` mode due to ARM64 incompatibility), you must update the `implementation_plan.md` explaining the *Why* before you write the *How*.

3. **No Phantom Artifacts**:
   - Temporary terminal commands (`run_command`) do not persist across session boundaries. Therefore, the outcome of any significant debugging effort must be distilled and deposited into either a **Knowledge Item (KI)**, an active **Walkthrough Document**, or the **Knowledge Base (`_agents/skills/`)**.

4. **Verify Memory Status Check**:
   - Whenever you are asked to "rebuild from scratch" or "recover", your immediate first action must be to read the prevailing `SKILL.md` documents and the `implementation_plan.md` to load constraints into your active context window. Do not guess what happened previously.

## Enforcement
Failure to abide by these rules guarantees that you will trap the USER in a cyclical failure loop. If you find yourself repeatedly typing the same debugging commands, stop immediately and ask yourself: "Where did I fail to document this the first time?"

## Mandatory TeraFlowSDN Hardening Checklist (Pre-Flight)

Before any system reconstruction or deployment (Local, ARM64, or Cloud), verify the following "Source of Truth" compliance points:

### 1. Architecture Compatibility (Exec Format Error)
- **Check**: All `Dockerfiles` (especially `slice`, `load_generator`, `monitoring`) must target the correct `grpc_health_probe` binary.
- **Verification**: Ensure `GRPC_HEALTH_PROBE_VERSION=v0.4.18` (or newer) and the architecture matches the target (e.g., `-linux-arm64` for Apple Silicon/ARM VMs).

### 2. Service Discovery (Kafka Connectivity)
- **Check**: `deploy/tfs.sh` and `src/common/tools/kafka/Variables.py` must point to the actual service name.
- **Verification**: In the current environment, the service is `kafka-public`. Ensure no components are hardcoded to the default `kafka-service` string.

### 3. Lifecycle Stability (Ready/Liveness)
- **Check**: `readinessProbe` and `livenessProbe` in component manifests (e.g., `nbiservice.yaml`, `sliceservice.yaml`).
- **Verification**: Enforce `initialDelaySeconds: 180` and `failureThreshold: 30` (or greater) to account for ARM64/GCP startup latency and gunicorn/env-var wait cycles.
