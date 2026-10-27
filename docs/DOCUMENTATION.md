---
title: Documentation index
summary: Map of project documentation and current workstreams.
status: active
owners: []
updated: 2026-10-27
related: [PROGRESS.md, architecture/overview.md, glossary.md]
---

# Documentation index

## Quick facts

- **Project:** Research-first infrastructure for next-concept text generation; see the [vision](../IDEA.md).
- **Stack:** Python 3.12, uv, pytest, and Ruff; PyTorch is the intended research baseline, not an implemented model.
- **Setup and checks:** [setup](guides/setup.md) and [testing](guides/testing.md). There is no model training or generation command yet.
- **Status:** [progress](PROGRESS.md) · **Plan:** [milestones](../PLAN.md).
- [Project overview](../README.md) · [Contributing](../CONTRIBUTING.md) · [Changelog](../CHANGELOG.md).

## Guides

- [Setup](guides/setup.md) — environment and optional tools.
- [Development](guides/development.md) — workflow and boundaries.
- [Testing](guides/testing.md) — checks and research evidence.

## Architecture and decisions

- [Architecture overview](architecture/overview.md) — intended dependency rule and research path.
- [ADR 0001: Modular monorepo](adr/0001-monorepo.md).
- [ADR 0002: Research baseline and development tools](adr/0002-research-tooling.md).
- [ADR 0003: Local code graph and explicit artifact tracking](adr/0003-local-graph-artifacts.md).

## Modules and workstreams

| Component | Documentation | Owner | State |
| --- | --- | --- | --- |
| Framework | [Framework](modules/framework/README.md) | Unassigned | Importable package skeleton; ML components planned |
| Language | [Language](modules/language/README.md) | Unassigned | Recipe location documented; models planned |
| Benchmarks | [Benchmarks](modules/benchmarks/README.md) | Unassigned | Planned |
| Runtime | [Runtime](modules/runtime/README.md) | Unassigned | Optional, planned |

## Specifications and templates

- [Specification template](templates/spec.md).
- [ADR template](templates/adr.md).
- No feature specifications are present yet; the [plan](../PLAN.md) identifies the first one.

## Research and terminology

- [Research reports](research/README.md) — reporting instructions; no reports yet.
- [Glossary](glossary.md) — terms and cautions.
