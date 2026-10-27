---
title: Progress
summary: Current foundation status and planned research workstreams.
status: active
owners: []
updated: 2026-10-27
related: [DOCUMENTATION.md, architecture/overview.md]
---

# Progress

## Snapshot

- **Phase:** Foundation; reference reconnaissance and reproduction come next.
- **Plan:** [milestones](../PLAN.md).
- **Summary:** The Python package is a skeleton; no NCM reproduction, trained model, benchmark results, or validated Rust runtime exist. Model quality, speed, parameter counts, and training feasibility remain unestablished.

## Modules

### Framework

- **Status:** Foundation in progress.
- **Now:** Package and development conventions exist; no training or inference functionality is implemented.
- **Next:** Specify and reproduce the official reference baseline before adapting algorithms.
- **Blockers:** Reference reproduction and its evidence have not yet been established.
- **History:** 2026-10-27 — Documented the current package and intended framework boundary ([module](modules/framework/README.md)).

### Language

- **Status:** Not started.
- **Now:** The recipe directory documents intent only; no configurations or trained models exist.
- **Next:** Define experiments after the reference and tokenizer work supports them.
- **Blockers:** A validated tokenizer and generator do not yet exist.
- **History:** 2026-10-27 — Documented planned recipes and their dependency direction ([module](modules/language/README.md)).

### Benchmarks

- **Status:** Not started.
- **Now:** No benchmark suite or measured results exist.
- **Next:** Specify reference evaluation, provenance, and measurement protocols.
- **Blockers:** Reference baseline has not been reproduced.
- **History:** 2026-10-27 — Documented the planned evaluation workstream ([module](modules/benchmarks/README.md)).

### Runtime

- **Status:** Not started; optional.
- **Now:** No Rust inference runtime or compatibility results exist.
- **Next:** Revisit only after a validated PyTorch reference and artifact contract exist.
- **Blockers:** Reference and artifact contracts are not yet validated.
- **History:** 2026-10-27 — Documented the optional runtime boundary ([module](modules/runtime/README.md)).
