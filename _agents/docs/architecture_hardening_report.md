# TeraFlowSDN ARM64 Architecture Resilience Report

## Executive Summary
This document serves as the technical "Source of Truth" for the TeraFlowSDN ARM64 hardening project. It defines why the official ETSI TFS distribution (v3.1.x) requires specific infrastructure and container patches to achieve stability on ARM64 platforms, including Apple M-series local development and Google Cloud `t2a` instances.

---

## 1. The AMD64 Architecture Barrier
The official ETSI TFS distribution is designed for `amd64` nodes. Several core services use hardcoded binary dependencies that trigger `exec format error` crashes on ARM64.

### Resolved: gRPC Health Probe Mismatch
- **Issue**: ETSI Dockerfiles download the `amd64` version of `grpc_health_probe`.
- **Hardening**: ALL core services have been patched to use `grpc_health_probe-linux-arm64` (v0.4.18).
- **Benefit**: Services now reliably report "Ready" status to Kubernetes on ARM64 nodes (Google Cloud t2a-standard-8).

---

## 2. Infrastructure Resilience (Anti-Restart Storms)
ARM64 virtualization (especially on MacOS) often experiences higher Disk I/O Wait during simultaneous container starts.

### Resolved: Readiness Probe Buffering
- **Issue**: Default 10–30s readiness probes kill services (NBI, Slice, Device) before they can initialize their Python/gunicorn workers. This leads to an infinite "Restart Storm."
- **Hardening**: Implemented a mandatory **180-second `initialDelaySeconds`** in all K8s manifests.
- **Benefit**: Guaranteed service stability during "Cold Boot" or VM recovery.

---

## 3. Persistent Connectivity Logic
Standard TFS deployment patterns often rely on specific environment-wide DNS or Ingress behaviors that vary across clouds.

### Resolved: Kafka Service Discovery
- **Issue**: Hardcoded logic expected `kafka-service`. Our environment uses `kafka-public`.
- **Hardening**: Patched `src/common/tools/kafka/Variables.py` to use cluster-relative discovery.

### Resolved: Ingress Prefix Collision (404/503 Bug)
- **Issue**: A global `rewrite-target: /` annotation in the default Ingress was stripping the `/tfs-api/` prefix required by the NBI Flask application.
- **Hardening**: Decoupled the Ingress into `tfs-ingress-webui` and `tfs-ingress-api` to preserve specific path prefixes.

---

## 4. Google Cloud Migration Readiness
The current repository baseline is now **Google Cloud Ready**. 

> [!IMPORTANT]
> To deploy this baseline to Google Cloud (GKE/Compute Engine on ARM64):
> 1. Use the **Hardened Manifests** in `/manifests/`.
> 2. Follow the **[recovery.sh](file:///Volumes/TFS_MIRROR/controller-develop/recovery.sh)** sequential deployment protocol.
> 3. Verify the **13-screen audit** as established in this repository.

---
**Baseline Owner**: Antigravity AI
**Status**: Architecture Verified & Hardened
