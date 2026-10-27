# Plan — Tesserakt

This plan follows [IDEA.md](IDEA.md); proposed capabilities are not yet implemented. Progress is tracked in [docs/PROGRESS.md](docs/PROGRESS.md).

## Objective and scope

Build reproducible research infrastructure for next-concept text generation, first reproducing the official baseline, then validating a trainable tokenizer and generator in a small end-to-end experiment. General chat, multimodal modeling, a plugin platform, and an unvalidated Rust runtime are out of scope initially.

## Decisions and boundaries

- [Monorepo](docs/adr/0001-monorepo.md): reusable `src/tesserakt` is independent of `recipes/language`; recipes depend on the framework.
- [Research and tooling](docs/adr/0002-research-tooling.md): Python/PyTorch, uv, pytest, Ruff, MIT; reference fidelity first.
- [Graph and artifacts](docs/adr/0003-local-graph-artifacts.md): local code-only Graphify, explicit Git LFS publication; no datasets or checkpoints in Git by default.

## Milestones

### M0 — Foundation

- [x] Establish package installation, locked development dependencies, documentation, collaboration instructions, local graph integration, and CPU checks.
- Exit: package imports, checks pass, and the repository makes no claim that an NCM model or baseline is working.

### M1 — Reference reconnaissance and reproduction

- **Goal:** establish an independently reproducible official baseline before adapting algorithms.
- **Specs first:** `docs/specs/reference/reproduction.md` — reference revision, environment, checkpoint and dataset terms, commands, measurement protocol, and acceptance criteria.
- [ ] Pin and inspect the paper, code revision, configuration, and licenses; map tokenizer/generator contracts and deviations — size M; parallelizable: yes; depends on: M0; done when a sourced reference analysis identifies tensor contracts and gaps.
- [ ] Record dataset and checkpoint provenance and installation requirements — size M; parallelizable: yes; depends on: M0; done when revisions, terms, and preprocessing are documented.
- [ ] Run an official TinyStories checkpoint and record outputs, hardware, software, latency, and memory — size L; parallelizable: no; depends on: reference and provenance; done when a clean checkout reproduces the stated behavior within recorded variation, or the exact blocker is documented.

### M2 — Trainable tokenizer

- **Goal:** demonstrate held-out reconstruction and a tiny-set overfit with restartable training.
- [ ] Specify tensor, codebook, loss, and checkpoint contracts against M1 — size M; parallelizable: no; depends on: M1.
- [ ] Implement and evaluate a reference-faithful tokenizer vertical slice — size L; parallelizable: no; depends on: approved contracts; done when gradients, reconstruction, usage/collapse diagnostics, reload, and deterministic evaluation are verified.

### M3 — Generator and end-to-end experiment

- **Goal:** train a small generator on frozen tokenizer codes and generate text.
- [ ] Specify level-wise objective, conditioning corruption, sampling, and serialization — size M; parallelizable: no; depends on: M2.
- [ ] Train and evaluate the end-to-end prototype against diagnostic baselines — size L; parallelizable: no; depends on: approved generator spec; done when loss, held-out samples, resources, and reproducible run provenance are recorded.

### M4 — Consolidation and controlled research

- [ ] Consolidate proven training, evaluation, and inference workflows into documented APIs and CLI — size L; parallelizable: yes after M3; done when a contributor can train, resume, generate, and reproduce evaluation.
- [ ] Profile and investigate scaling, conditioning, and fair autoregressive comparisons — size L; parallelizable: yes after M3; done when controlled experiments disclose total-system costs and limitations.
- [ ] Consider a Rust runtime only after PyTorch behavior is frozen and compatibility and performance can be measured.

## Quality and risks

Every behavioral change requires an approved spec, targeted checks, documentation, and measured experiments where relevant. Protect dataset splits and checkpoint provenance; never infer general intelligence or speed superiority from narrow results. Constrained GPU memory and reference environment availability are measured risks, not assumed capabilities. Preserve tokenizer, generator, and total-system accounting separately.
