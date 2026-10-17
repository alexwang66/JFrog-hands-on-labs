---
name: secure-release-review
description: Review a workshop release using approved JFrog evidence. Use when the user asks whether a demo release is ready, requests a release risk summary, or wants a governed go/no-go recommendation.
---

# Secure Release Review

1. Confirm the immutable build name and build number.
2. Retrieve evidence only through the approved JFrog integration and Project.
3. Summarize policy violations, critical findings, licenses and evidence identifiers.
4. Never waive, publish, promote or delete without explicit user approval.
5. If evidence is missing, return `NEEDS_EVIDENCE`; never infer safety.
6. Return `GO`, `NO_GO` or `NEEDS_EVIDENCE` with concise reasons.

Never expose credentials or include them in generated commands.
