---
title: Glossary
summary: Terms used in the Tesserakt research plan and documentation.
status: active
owners: []
updated: 2026-10-27
related: [architecture/overview.md, research/README.md]
---

# Glossary

These terms describe the research direction, not implemented capabilities. See [IDEA.md](../IDEA.md) for the project vision and source attribution.

- **Next-Concept Modeling (NCM):** the referenced approach to text generation using hierarchical discrete codes and coarse-to-fine prediction.
- **Concept code:** a learned discrete latent representation; it is not necessarily a human-readable concept or evidence of human-like reasoning.
- **Multiscale VQ tokenizer:** the planned encoder, quantizers, and decoder that map text to hierarchical codes and reconstruct it.
- **Generator:** a model intended to predict those codes level by level, conditioned on earlier levels.
- **Reference reproduction:** establishing the behavior of the official NCM implementation under a recorded protocol before adapting core algorithms.
- **Recipe:** model-family-specific configuration and experimental protocol, separate from reusable framework code.
- **Checkpoint:** a saved model artifact; reproducible experiments also need their configuration and provenance.
- **Baseline:** a reference procedure or comparator evaluated under a documented protocol. A fair comparison accounts for the full system and its costs.
