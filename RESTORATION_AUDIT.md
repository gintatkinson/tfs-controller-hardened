# TFS Restoration Technical Audit Report

Date: 2026-03-23
Repository: gintatkinson/xgai-cogctrl
Environment: ARM64 Multipass VM (tfs-vm)

## Executive Summary
This audit identifies several "surgical hacks" and deviations from the ETSI TFS baseline that were implemented during the initial restoration. These modifications create technical debt and make the deployment brittle.

## Identified Deviations

### 1. WebUI Ingress Redirect
- **Status**: Non-standard
- **Deviation**: Base URL moved from `/webui` to `/`.
- **Root Cause**: Routing errors in standard pathing were bypassed rather than fixed.
- **Remediation**: Restore `/webui` in manifests and fix internal Flask pathing/middleware.

### 2. WebUI Static Assets (Symlink Hack)
- **Status**: Manual runtime patch
- **Deviation**: Symlink created manually: `templates/js -> static/js`.
- **Root Cause**: `topology.js` and other scripts are located in the templates directory but referenced as static assets.
- **Remediation**: Move JS files to `static/js/` and update `url_for` references in HTML templates.

### 3. DeviceService Image & Decorator Patch
- **Status**: External dependency & runtime injection
- **Deviation**: Using `xgaitfs/deviceservice:latest` with an `initContainer` patching `Decorator.py`.
- **Root Cause**: Compatibility issues between the service and the standard `Decorator.py` signatures, or ARM64-specific metrics failures.
- **Remediation**: Apply compatibility stubs to the source mirror's `Decorator.py` and revert to cluster-local `localhost:32000/tfs/device:dev` image.

### 4. Database Discovery
- **Status**: Hardcoded hostnames
- **Deviation**: Services point to `cockroachdb-public.crdb.svc.cluster.local` or similar hardcoded strings.
- **Remediation**: Standardise on `CRDB_SERVICE_HOST` environment variables and TFS service discovery.

## Next Steps
1. Register issues on GitHub (Completed).
2. Apply source mirror fixes via VM (Planned).
3. Rebuild and redeploy (Planned).
