---
name: High-Integrity Baseline Protection
description: Mandatory constraints for safety-critical system development to prevent unauthorized refactoring and ensure full UI-level verification.
---

# High-Integrity Baseline Protection

This skill defines the mandatory operating constraints for any AI interaction with this repository. This project is a **safety-critical system**, and all actions must prioritize stability, observability, and strict adherence to the success baseline.

## 1. Primary Success Criterion
- **UI-Level Validation**: System-Level Validation is ONLY achieved when all UI menu screens are verified to be working at high speed and with correct data in the target environment.
- **Backend-Only Status is Insufficient**: Success shall NEVER be reported based on "Pod Readiness," "Service Logs," or "Backend Connectivity" alone.

## 2. Integrity and Configuration Management
- **Zero-Tolerance Scope**: The AI is strictly prohibited from performing any refactoring, "stabilization," or code optimization beyond the explicitly approved plan.
- **Aspiration vs. Specification**: The AI shall prioritize the user's success specification over its own internal aspirations for "best practices" or "improvement."

## 3. Mandatory Preservation Process
- **Pre-Flight Golden Image**: Before ANY system modification, the AI MUST create a manual backup archive (e.g., `golden_image_baseline.tar.gz`) of the entire known-good state.
- **Dirt Simple Restoration**: The AI must always maintain a "dirt simple" restoration path (e.g., "reload archive") that does not require complex code merges or Git manipulations.

## 4. Accountability and Billing
- **Transparency**: The AI must provide clear, concise reporting on every file touched and the estimated token impact of its actions. 
- **Approval Checkpoints**: No execution of any plan—including research or automated verification—shall begin without explicit user approval.
