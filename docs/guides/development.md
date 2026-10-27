---
title: Development
summary: Development workflow and research documentation expectations.
status: active
owners: []
updated: 2026-10-27
related: [setup.md, testing.md, ../architecture/overview.md]
---

# Development

Set up the environment using [setup](setup.md). Develop small vertical slices tied to real experiments, not hypothetical ML implementations. Keep reusable code in `src/tesserakt` and model-specific configuration and recipes outside the framework. See the [architecture overview](../architecture/overview.md).

For consequential design changes, use the [spec](../templates/spec.md) and [ADR](../templates/adr.md) templates. Document reference fidelity and deviations, data and checkpoint provenance, configuration, limitations, and reproducible evidence as relevant. Add a changelog fragment for user-visible changes and update progress when status changes. See [contributing](../../CONTRIBUTING.md) for review expectations and [testing](testing.md) for checks.
