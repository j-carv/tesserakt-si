---
title: Modular monorepo
summary: Keep the reusable framework and model recipes together with a one-way dependency.
status: active
owners: []
updated: 2026-10-27
related: [../architecture/overview.md]
---

# ADR 0001: Modular monorepo

- **Status:** Accepted
- **Context:** The framework and first language-model recipe must evolve together while the research interfaces are still unproven.
- **Decision:** Keep them in one repository, with reusable Python framework code in `src/tesserakt` and model-specific recipes separate. Recipes depend on the framework, never the reverse.
- **Consequences:** Changes can be validated together without premature cross-repository integration. Boundaries must remain explicit; model-specific assumptions do not belong in framework code. A future split requires evidence and a new decision.
- **Source:** [IDEA.md §6](../../IDEA.md#6-repository-strategy-one-modular-monorepo).
