---
name: Linux Native Development
description: Mandatory rules for a standalone xgai-cogctrl environment to prevent host-propagation bugs.
---

# Linux Native Development Skill

## Overview
This skill defines the mandatory workflow for the xgai-cogctrl project, which is case-sensitive and Linux-native. 

## Mandatory Rules
1.  **Direct VM Edits**: NEVER use tools (like code editors or agents) to modify the host-mounted path `/Volumes/TFS_MIRROR/`. ALL code modification MUST happen inside the VM using `multipass exec`.
2.  **Standalone Mode**: Treat the `xgai-cogctrl` repository as the ONLY source of truth. Ignore all upstream repository branches once the standalone mirror is established.
3.  **ARM64 Compatibility**: Every change must be verified for ARM64 architecture (aarch64). Check images and binaries using `uname -m` or `docker inspect`.
    - **Health Probes**: Always use `grpc_health_probe-linux-arm64` (v0.4.18+) in Dockerfiles to prevent `exec format error`.
    - **Library Links**: Use `pkg-config` for dynamic library discovery (e.g., `glib-2.0`) to avoid hardcoded x86 paths in Makefiles.
4. **Prometheus Metric Safety**: To prevent `ValueError: Duplicated timeseries` during pod restarts or concurrency:
    - **Call-Time Registration**: Metrics should be retrieved/registered at call-time using a `MetricsPool` pattern rather than module-level global initialization.
    - **Fail-Safe Mechanism**: Use a `DummyMetric` class to catch and swallow `ValueError` if a duplicate registration is attempted.
5. **WebUI Asset Resilience**: 
    - **Absolute Pathing**: Always use `os.path.join(os.path.dirname(__file__), ...)` for Flask `send_from_directory` to prevent `FileNotFoundError` caused by differing container WORKDIRs.
    - **Ingress Coverage**: Ensure `nginx_ingress_http.yaml` explicitly covers all service prefixes (e.g., `/webui`, `/tfs-api`) to avoid 404/503 gaps.

## Rigorous Validation (No Waiting)
To prevent "transient success" reports without wasting tokens on idle waiting:
1.  **Atomic Transaction Check**: Every "fix" must be verified by a complete end-to-end flow:
    - **Write**: Create/Inject data (e.g., `DescriptorLoader`).
    - **Read**: Query the data via CLI (e.g., `ContextClient`).
    - **Interact**: Verify the data renders in the WebUI.
2.  **Resource Buffer Check**: Use `kubectl top pods` to confirm that the service has at least a 20% "Headroom" above its current usage. If it is within 5% of its limit, it is NOT stable regardless of uptime.
3.  **Targeted Log Scrubbing**: Immediately after a transaction, grep logs for `ERROR`, `Timeout`, or `Connection Refused`. If the logs are noisy or show retries, the system is brittle.
4.  **No Arbitrary Waiting**: If the atomic transaction and resource buffer checks pass, the system is considered verified.
