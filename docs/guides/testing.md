---
title: Testing
summary: Development checks and evidence expected from research changes.
status: active
owners: []
updated: 2026-10-27
related: [setup.md, development.md]
---

# Testing

From the repository root after `uv sync`, run:

```sh
uv run pytest
uv run ruff check .
uv run ruff format --check .
```

Add focused tests for behavior and regressions as features are implemented. For research changes, distinguish unit and integration tests from a reproducible experiment: report configuration, data provenance, hardware, metrics, and limitations. Passing development checks alone does not establish NCM reproduction, model quality, or performance.
