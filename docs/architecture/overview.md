---
title: Architecture overview
summary: Planned monorepo boundaries and the research path.
status: active
owners: []
updated: 2026-10-27
related: [../adr/0001-monorepo.md, ../adr/0002-research-tooling.md]
---

# Architecture overview

The initial design is a Python/PyTorch monorepo. The framework lives under `src/tesserakt`; model-family recipes live separately under `recipes`. These are boundaries for future work, not a claim that NCM components are implemented.

**Dependency rule:** recipes depend on reusable framework interfaces; the framework must not depend on a specific recipe, dataset, model size, or checkpoint. Benchmarks may use the framework without silently modifying reference implementations. A future Rust runtime must consume specified artifacts and match a validated PyTorch reference.

The intended research path is text → multiscale quantized tokenizer → hierarchical codes → next-concept generator → tokenizer decoder → text. Train the tokenizer first, then freeze it while training the generator. Reproduce the official reference baseline before adapting algorithms; document deviations and experimental evidence. No reproduction or trained model exists yet.

See [IDEA.md](../../IDEA.md), [monorepo decision](../adr/0001-monorepo.md), and [research and tooling decision](../adr/0002-research-tooling.md).
