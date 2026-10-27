---
title: Research baseline and development tools
summary: Establish reference fidelity and the initial Python development workflow.
status: active
owners: []
updated: 2026-10-27
related: [0001-monorepo.md, ../guides/testing.md]
---

# ADR 0002: Research baseline and development tools

- **Status:** Accepted
- **Context:** The project needs a reproducible reference before proposing changes to NCM, with a consistent Python development workflow.
- **Decision:** Use Python and PyTorch as the initial correctness baseline. Reproduce the official NCM baseline before changing core algorithms. Manage the environment with uv, test with pytest, and lint and format with Ruff. Maintain the project under the MIT license, with Tesserakt SI as copyright holder.
- **Consequences:** Performance and novelty claims require measured evidence. The original NCM authors retain attribution, and the current upstream license must be verified before copying code. Rust inference is a later option, not a prerequisite for the first experiment.
- **Sources:** [IDEA.md §§2, 5, 10](../../IDEA.md); [NCM paper](https://arxiv.org/abs/2610.14162); [official reference](https://github.com/HazyResearch/ncm); [PyTorch](https://pytorch.org/); [uv](https://docs.astral.sh/uv/); [pytest](https://docs.pytest.org/); [Ruff](https://docs.astral.sh/ruff/); [MIT license](https://opensource.org/license/mit).
