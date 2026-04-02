---
description: Mandatory pre-flight checklist and command sequence for executing a hardened, ARM64-compliant deployment of TeraFlowSDN.
---

# Hardened Build Workflow
Run this workflow by typing `/hardened_build`

## Step 1: Pre-Flight Architecture Audit
Before any compilation begins, verify and statically patch the codebase for ARM64 compatibility according to the `linux_native` skill requirement:
1. Examine `src/pathcomp/backend/Dockerfile`. If the `apt-get install` directive lacks `uuid-dev`, pause and manually patch it.
2. Examine `src/pathcomp/backend/Makefile`. Check if the `CFLAGS` explicitly maps the ARM64 path (`-I/usr/lib/aarch64-linux-gnu/glib-2.0/include`). If not, patch it before continuing.

## Step 2: Database Persistence Pre-Flight Audit
Verify that the native Single-Node databases possess Bound PVCs to comply with the `Restoration` skill requirement:
1. Review `manifests/cockroachdb/single-node.yaml`. Does it explicitly declare a `volumeClaimTemplates` using the storage class `microk8s-hostpath`? If not, pause and patch it.
2. Review the QuestDB and NATS manifests to ensure they are bypassing ephemeral `emptyDir` mounts in favor of explicitly bound PVC configurations. 

## Step 3: Mandatory Validation Checklist Checkpoint
Output a compliance report satisfying the `[forbidden-builds.md]` User Rule. 
**Wait for explicit USER approval** before passing to Step 4. Do not auto-run.

## Step 4: Execute Native Deployment
Once the user approves the static audit checklist, you may safely execute the native deployment logic. 
// turbo
1. Re-sync Docker binary mappings:
`multipass exec tfs-vm-fresh -- sudo ln -sf /snap/bin/docker /usr/bin/docker`
2. Execute the synchronized codebase:
`multipass exec tfs-vm-fresh -- bash -c "sudo su - ubuntu -c 'cd /home/ubuntu/tfs-main && source my_deploy.sh && ./deploy/all.sh > /home/ubuntu/tfs_build.log 2>&1'"`

## Step 5: Post-Completion Health Verification
Monitor `kubectl get pods -A` exclusively for `ImagePullBackOff` or `CrashLoopBackOff`, and trace any defects immediately to the explicit sub-component build log stored in `tmp/tfs/logs`.
