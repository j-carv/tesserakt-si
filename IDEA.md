# Tesserakt

> **Research-first infrastructure for Next-Concept Modeling.**
>
> **Status:** Founding vision and implementation plan · **Date:** 2026-10-27 · **Document:** `IDEA.md`

## 1. Executive vision

**Tesserakt** is a serious, open-source research and engineering project dedicated to building, training, evaluating, and eventually serving generative models based on **Next-Concept Modeling (NCM)**. The framework and its models will be developed **together in one modular monorepo initially**, in small, reproducible steps: we will not spend months building an untested abstraction layer, and we will not ship models whose training and evaluation cannot be reproduced.

Our first deliverable is **Tesserakt Language**, a compact text-generation model trained from scratch. A tiny proof-of-concept (~5 million *generator* parameters, subject to feasibility) will validate the entire training-to-inference pipeline. A subsequent research model will target roughly **30 million generator parameters**. Neither size is a promise of useful conversational intelligence; both are experimental targets that may change based on evidence.

The longer-term ambition is to establish Tesserakt as a practical, scientifically credible toolkit for **coarse-to-fine, parallel, concept-code-based generation**, with extensible training pipelines, transparent benchmarks, and an efficient inference runtime. Other tasks and model families may follow, but text is the exclusive initial focus.

**This is not a toy, a wrapper marketed as a new architecture, or a race to produce a flashy demo.** Every major claim must be supported by a measurable result; every significant implementation must be testable; and scientific provenance must remain explicit.

## 2. Scientific foundation and attribution

Tesserakt is inspired by and initially grounded in:

- **Kumbong et al. (2026), _Next-Concept Modeling: Fast, Parallel Coarse-to-Fine Text Generation_.** Paper: https://arxiv.org/abs/2610.14162
- **Official reference implementation:** https://github.com/HazyResearch/ncm (MIT-licensed at the time of planning; verify the repository's current license before copying code).
- **Released reference checkpoints:** https://huggingface.co/hazyresearch/ncm-checkpoints
- **Research overview:** https://hazyresearch.stanford.edu/blog/2026-10-12-ncm

In the published NCM formulation, a **multiscale residual vector-quantized text autoencoder** (VQ-VAE-style tokenizer) maps token sequences to hierarchical discrete codes. A **Next-Concept Transformer** learns to generate those codes level by level: positions within each level are predicted in parallel; later levels refine the earlier reconstruction. The trained text decoder converts the final representation back into tokens.

The research uses a two-stage procedure: (1) train the multiscale tokenizer, then (2) freeze it and train the generator on hierarchical codes. The generator uses level-aware training and perturbation of conditioning codes to improve robustness. Prompt-conditioned generation can use a prefix-LM attention pattern.

**Scientific caution:** these internal codes are learned latent representations, not guaranteed human-readable semantic concepts or evidence of human-like thinking. NCM's reported generation-speed advantages are against the specific diffusion baselines, tasks, and configurations in the original paper; they are **not** general proof that NCM is faster or better than every autoregressive model.

Tesserakt will transparently distinguish:

1. **Reproduction:** behavior and algorithms implemented from the paper/reference code.
2. **Adaptation:** engineering choices made to support smaller models or local hardware.
3. **Research contribution:** new ideas requiring novelty review, controlled experiments, and ablations.

We will not claim authorship of the original NCM architecture. Any reused code will retain required copyright notices, attribution, and license compliance.

## 3. Mission, objectives, and non-goals

### 3.1 Primary objectives

1. **Reproducibility:** reproduce an official NCM generation/evaluation baseline before changing core algorithms.
2. **End-to-end training:** provide functioning training pipelines for the multiscale tokenizer and generator, including resumption, validation, and deterministic configurations wherever practical.
3. **Compact language generation:** train Tesserakt Language from scratch and investigate the behavior of NCM at small parameter counts.
4. **Fair evaluation:** compare similarly constrained NCM and autoregressive baselines, accounting for the **entire** model, data, training compute, memory, and end-to-end generation cost.
5. **Developer usability:** offer documented Python APIs and a stable, minimal CLI for preparing data, training, evaluating, and generating.
6. **Extensible research:** make meaningful ablations straightforward, so that researchers can investigate codebook sizes, hierarchy depth, tokenization, loss weighting, conditioning, and generation strategies.
7. **Efficient inference:** after proving correctness in PyTorch, investigate a Rust runtime with measured compatibility and performance.
8. **Open science:** publish appropriately licensed code, configs, experiment definitions, technical reports, and, when legally and operationally feasible, checkpoints.

### 3.2 Secondary objectives (after a working language model)

- Prompt-conditioned completion and, later, simple instruction following.
- Multi-block generation for responses longer than a single fixed output block.
- Fine-tuning and domain-specific models, once the base training path is stable.
- Quantization and CPU/GPU runtime optimization.
- Exploratory research on adaptive, possibly region-dependent concept refinement—**only after** reviewing existing work and establishing fixed-depth baselines.

### 3.3 Explicit non-goals for the first release

- Competing with frontier LLMs in general knowledge, complex reasoning, or chat quality.
- Supporting multimodal generation, 3D meshes, medical diagnosis, or code assistants immediately.
- Training billion-parameter models on consumer hardware.
- Building a Rust training stack before the reference PyTorch implementation is correct.
- Inventing a broad plugin ecosystem, distributed orchestration layer, model hub, web UI, or hosted service before the foundational model runs.
- Describing a research hypothesis as a demonstrated improvement.

## 4. First model: Tesserakt Language

**Model family:** `Tesserakt Language`  
**First proof of concept:** `tesserakt-language-5m` (working name)  
**First scaled research target:** `tesserakt-language-30m` (working name)  
**Initial language:** English  
**Initial tasks:** unconditional short text generation and short prefix-conditioned completion  
**Later tasks:** simple instruction-following, short question answering, and short creative writing after appropriate training and evaluations

These parameter targets refer to the **generator only**, unless a report explicitly says otherwise. The text tokenizer/encoder/decoder can be substantial and must always be reported separately, alongside total checkpoint size, memory demand, and decoding cost. Model names and reported counts will be reconciled with measured parameter counts before release.

### 4.1 Initial workflow

```text
raw text
   │
   ▼
text tokenization / vocabulary
   │
   ▼
multiscale VQ tokenizer training
   ├── encoder
   ├── quantizers / per-level codebooks
   └── reconstruction decoder
   │
   ▼
frozen tokenizer → hierarchical discrete code targets
   │
   ▼
Next-Concept Transformer training
   │
   ▼
coarse-to-fine sampling (parallel within each level)
   │
   ▼
VQ decoder → text tokens → readable text
```

### 4.2 Conditional generation

The first generation milestone is **unconditional** text; prefix-conditioned completion follows. For conditioning, start from the method described by the original NCM work rather than assuming chat can be added merely with a prompt template.

A conversational interface is a later **training objective and protocol**, not an intrinsic capability of NCM. Multi-block continuation likewise requires separate design and evaluation for boundary continuity, stopping behavior, context handling, and repetition.

### 4.3 Configurations are hypotheses, not architecture facts

Candidate early experiments include a short 64–128-token output block, 3–4 concept levels, and small codebooks. The exact level lengths (for example, `4 → 16 → 64 → 128`) and model dimensions will be selected only after confirming constraints and compatibility with the reference architecture. A previous discussion mentioned an 8-layer/512-hidden prototype; **do not assume** that this equals 30M parameters without calculating the actual parameter count (including embeddings and heads).

The first network may deliberately be smaller than 5M if necessary to validate a fully working training pipeline.

## 5. Technical strategy

### 5.1 Training and research stack

- **Python + PyTorch:** canonical training implementation and correctness baseline.
- **CUDA:** preferred GPU acceleration; mixed precision only where supported and numerically safe.
- **Hugging Face Datasets / compatible data loaders:** reproducible dataset ingestion.
- **Safetensors or a documented safe, versioned checkpoint format:** model weights; optimizer/resume state saved separately where needed.
- **TensorBoard or equivalent:** training curves, resource metrics, and sampled outputs.
- **Pytest + automated CI:** deterministic functional tests, smoke tests, and regression tests.
- **Rust:** future inference runtime; not required for the first successful experiment.

### 5.2 Hardware assumptions

Local research starts from an **NVIDIA RTX 3050 with 8 GB VRAM**, with additional experimentation possible on a **16 GB Apple Silicon Mac**. Available GPU memory constrains batch size, activations, optimizer state, sequence length, and tokenizer training. Small models **may** fit through gradient accumulation, activation checkpointing, and carefully chosen precision, but feasibility must be measured—not assumed.

If a meaningful training run exceeds local resources, renting GPU time is acceptable when its purpose, budget, and expected learning value are documented. No stage requires cloud infrastructure by default.

### 5.3 Data policy

Start with **TinyStories** for basic language-learning and reconstruction experiments, following its actual terms and documenting its limitations. Later expand to broader, properly licensed and carefully filtered English corpora. Every dataset needs a provenance record: source, version/revision, license/terms, download method, preprocessing, train/validation/test splitting, deduplication strategy, and known risks.

Keep training and evaluation splits clean. Avoid contamination, hidden handpicked validation examples, sensitive/private data, or data without a justified right to use. Do not assume that high-quality story continuation implies general language competence.

### 5.4 Framework design principles

- **Reference fidelity first:** reproduce core behavior before optimizing or rewriting.
- **Vertical slices before horizontal platforms:** every reusable abstraction should support a real experiment.
- **Correctness before speed:** validated outputs and gradients precede performance tuning.
- **Explicit boundaries:** tokenizer, generator, data, training, evaluation, and runtime must have clear contracts.
- **Configuration-driven experiments:** no undocumented hyperparameters or hidden magic defaults.
- **Device neutrality where realistic:** no CUDA-only design at the core API level, while accepting CUDA-specific accelerations behind interfaces.
- **Readable code:** prioritize maintainability over cleverness; explain nontrivial math and tensor shapes.
- **No premature rewriting:** Rust inference should be benchmarked against a frozen PyTorch reference before replacing it.

## 6. Repository strategy: one modular monorepo

**Architectural decision (2026-10-27): Tesserakt Framework and Tesserakt Language will initially live in the same `tesserakt` Git repository.** They are separate *logical products*, not separate repositories or independently duplicated implementations. This is intentional: NCM remains experimental, and the first model will validate and shape the APIs of the framework. Creating several repositories before we have a working training-to-inference loop would increase integration friction without scientific benefit.

### 6.1 Boundaries and dependency rule

| Component | Responsibility | Dependency direction |
| --- | --- | --- |
| **Tesserakt Framework** | Reusable NCM building blocks: model, tokenizer, training, data, evaluation, Python inference and CLI | Must **never depend on a particular Tesserakt Language recipe or checkpoint** |
| **Tesserakt Language** | Model-family recipes, configs, training/evaluation protocols, and eventually published checkpoints | Depends on the framework's public/experimental interfaces |
| **Tesserakt Benchmarks** | Reproducible comparisons, autoregressive baselines, measured results | May import the framework; must not silently change reference implementations |
| **Tesserakt Runtime** | Future Rust inference engine and compatibility tests | Consumes specified/exported artifacts; must match validated PyTorch behavior |

**Non-negotiable invariant: the framework does not depend on Tesserakt Language; Tesserakt Language depends on the framework.** Framework source code must not hard-code TinyStories assumptions, the `5m`/`30m` configs, model-specific vocabulary paths, dataset locations, or checkpoint IDs. A new model family must be expressible using reusable interfaces and its own recipes unless a measured requirement warrants a framework extension.

### 6.2 Target directory structure

This is a planned layout, **not** a claim that the modules already exist:

```text
tesserakt/
├── IDEA.md
├── README.md
├── LICENSE
├── CITATION.cff
├── pyproject.toml
├── src/
│   └── tesserakt/            # Installable Python framework
│       ├── core/            # Shared tensors, interfaces, model contracts
│       ├── tokenization/    # Text tokenizer, multiscale VQ tokenizer
│       ├── models/          # Reusable NCM generators/configuration
│       ├── training/        # Tokenizer/generator training, checkpoints
│       ├── data/            # Generic datasets and preprocessing
│       ├── inference/       # Validated PyTorch inference
│       ├── evaluation/      # Metrics and evaluation utilities
│       └── cli/             # Developer commands
├── recipes/
│   └── language/            # Tesserakt Language model family (not core)
│       ├── 5m.yaml
│       ├── 30m.yaml
│       └── README.md
├── experiments/             # Tracked run configs, reports, ablations
├── benchmarks/              # NCM vs autoregressive baselines
├── tests/                   # Unit, integration, and regression tests
├── docs/                    # Architecture, reference fidelity, developer docs
├── runtime/                 # Later; optional until PyTorch is validated
│   └── rust/
└── scripts/                 # Small, auditable development utilities
```

The Python framework starts as **one installable package**, not a collection of independently versioned micro-packages. Recipes configure models and experiments; they do not fork copies of the model architecture. Checkpoints, cached data, credentials, and large raw run artifacts must remain out of Git unless intentionally released through an appropriate artifact store.

### 6.3 Co-development and stability policy

- Build a **vertical slice** first: train a tiny tokenizer, train a tiny generator, reload a checkpoint, and generate text. Only then generalize repeated patterns into framework APIs.
- Keep model-specific decisions in `recipes/language/`; shared architecture and algorithms belong in `src/tesserakt/`.
- Define and test explicit contracts between tokenizer, generator, checkpoint format, training, and inference. Validate serialization and reproducibility across the boundaries.
- APIs are allowed to change during early research, but incompatible changes must be documented with the experiment/checkpoint versions they affect.
- Do not develop a hypothetical universal architecture platform, plugin system, or distributed service before an experiment demonstrates the need.
- The `5m` prototype is an **integration and science validation target**, not an afterthought postponed until the entire framework is feature-complete.

### 6.4 When separation into repositories becomes justified

Revisit a split **only if practical evidence supports it**, for example when:

1. The reusable framework has a sufficiently stable public API and independent consumers.
2. Language-model experiments no longer require continuous core changes.
3. Different components demonstrably need separate distribution, release cadence, access policies, or maintainers.
4. The Rust runtime develops independent packaging and compatibility requirements.

A possible future organization could have separate `tesserakt`, `tesserakt-models`, `tesserakt-runtime`, and `tesserakt-benchmarks` repositories. **That is a future option, not the initial design.** Any split must preserve testable interfaces, artifact compatibility, continuous integration, provenance, and a documented migration plan.

## 7. Development roadmap and stage gates

Each phase has an artifact and a falsifiable **exit criterion**. Stages can be revisited if evidence requires it.

### Phase 0 — Scientific reconnaissance and reference reproduction

**Work:** read the NCM paper and key equations; inspect the official code and published configs; identify tokenizer/generator tensor contracts; reproduce a released TinyStories checkpoint; measure quality, latency, device compatibility, and peak memory.

**Deliverables:** `docs/reference-analysis.md`, environment lock/installation instructions, a reference evaluation script, recorded baseline results, and a list of implementation gaps.

**Exit:** a clean checkout can reproduce documented reference generation/evaluation behavior within stated variation. If not, record precisely what fails and why before proceeding.

### Phase 1 — Trainable tokenizer, end to end

**Work:** implement or faithfully adapt trainable multiscale VQ tokenizer components; establish tokenizer vocabulary and codebook handling; implement reconstruction, relevant regularization, nested-dropout behavior, and validation; save/load checkpoints.

**Deliverables:** tokenizer trainer, tests of tensor shapes and gradients, reconstruction visualizations/text samples, codebook usage and collapse diagnostics, restartable training.

**Exit:** the tokenizer demonstrably learns to reconstruct held-out examples, including a tiny-set overfit test; training, reload, and deterministic evaluation work. No invented numerical quality threshold: establish and document thresholds from baseline feasibility experiments.

### Phase 2 — Small NCM generator (~5M target)

**Work:** freeze the tokenizer; encode hierarchical targets; train the Next-Concept Transformer using the documented level-wise objective, conditioning corruption, and correct attention conventions; implement level-by-level parallel sampling and decoding.

**Deliverables:** a complete `tesserakt-language-5m` experiment with config, seed, training curves, checkpoint(s), samples, and reproducible evaluation.

**Exit:** training beats intentionally simple diagnostic baselines, loss declines on a representative controlled dataset, held-out generations are not just rote memorization, and an independent run reproduces the procedure. A demo alone is not acceptance.

### Phase 3 — Minimal developer framework

**Work:** consolidate the proven path into a clean API and CLI; implement dataset preparation, run manifests, resumption, validation, logging, and meaningful error messages. Avoid building features not demanded by working experiments.

**Target user experience** (proposed commands, not implemented yet):

```bash
tesserakt tokenizer train --config configs/tokenizer/tinystories.yaml
tesserakt train --config configs/language-5m.yaml
tesserakt evaluate --model runs/language-5m
tesserakt generate --model runs/language-5m --prompt "Once upon a time"
```

**Exit:** a contributor can set up, train a small example, resume it, generate text, and reproduce the evaluation using public instructions; automated tests cover the critical path.

### Phase 4 — Controlled scaling (~30M generator target)

**Work:** scale only after profiling; tune hierarchy and codebooks with one-factor-at-a-time or clearly designed ablation experiments; investigate quality-versus-cost trade-offs; improve memory use without silently changing the scientific objective.

**Deliverables:** scaled model, resource and quality benchmarks, parameter accounting, and documented deviations from the 5M configuration.

**Exit:** results are reproducible, improvements and regressions are reported, and a larger model demonstrates a justified value proposition. Reaching exactly 30M is less important than a sound experiment.

### Phase 5 — Conditioning and language utility

**Work:** prefix-conditioned continuation; evaluation of conditioning strength; a carefully scoped instruction-tuning dataset; later, experimental generation across multiple blocks with boundaries and stopping criteria.

**Deliverables:** tests for prompt fidelity, repetition, fluency, formatting, and continuation quality.

**Exit:** measurable improvement on task-specific held-out tests without catastrophic loss of general text quality. **Do not advertise a general-purpose assistant unless evidence supports it.**

### Phase 6 — Comparative research and publication-grade results

**Work:** build at least one well-tuned autoregressive Transformer baseline and, where feasible, comparable diffusion/NCM reference configurations. Report generator-only versus total-system parameter counts; train compute and data exposure; effective tokens/second; wall-clock latency; peak VRAM; tokenizer reconstruction quality; end-to-end decode cost; and output quality.

**Deliverables:** benchmark suite, reproducibility manifest, ablation tables, limitations, and technical report.

**Exit:** independent readers can assess the fairness of comparisons and reproduce the reported protocol. Negative results count as valid research.

### Phase 7 — Rust runtime (optional, evidence-driven)

**Work:** export a frozen model; implement codebook operations, level-wise generation, and text decoding; verify numerical and textual agreement with PyTorch where deterministic; benchmark Rust against PyTorch on the same hardware, including startup and memory.

**Exit:** runtime output is demonstrably compatible and performance claims use measured end-to-end results. It ships only if the engineering/maintenance cost is justified.

## 8. Research questions

Tesserakt should answer questions, not merely accumulate features.

**RQ1 — Small-scale viability:** Does NCM train reliably at ~5M and ~30M generator parameters? Which failure modes dominate at low capacity?

**RQ2 — Reconstruction bottleneck:** How do tokenizer quality, codebook utilization, and residual hierarchy affect downstream generative quality?

**RQ3 — Efficiency frontier:** For equal or transparently comparable compute budgets, how does NCM compare with small autoregressive Transformers in quality, latency, throughput, and total memory footprint?

**RQ4 — Hierarchy trade-offs:** How do level count, level lengths, codebook sizes, and loss weighting influence generation and reconstruction?

**RQ5 — Conditioning:** How robustly can compact NCM models use prefixes and follow simple instructions?

**RQ6 — Adaptive refinement (future):** Can generation allocate less computation to easy inputs or regions without unreasonable degradation? The original authors already mention adaptation to difficulty as future work; **novelty must not be asserted without a literature review and a genuinely distinct mechanism**.

The first milestone is **not** a paper. It is a reliable experimental foundation from which publication-worthy results may emerge.

## 9. Evaluation and benchmark protocol

### 9.1 Required measurements

- **Tokenizer:** reconstruction token accuracy, held-out reconstruction error/loss, codebook perplexity/usage, dead-code rate, behavior by level, tokenizer parameter count.
- **Generator:** training/validation loss by level, stability, reproducibility across seeds, distributional text-quality measures, manual blinded examples, repetition, and diversity.
- **Conditioned tasks:** completion relevance and instruction adherence with predeclared scoring rules.
- **Efficiency:** end-to-end latency, throughput, number of generator evaluations, decoder overhead, peak allocated VRAM/RAM, checkpoint size, total parameter count, training time, and estimated training compute where available.
- **Comparisons:** at least one trained AR baseline; compare same datasets and splits, similar training token/compute budgets, tuned inference settings, and explicit total-system accounting.

### 9.2 Benchmark integrity

- Declare hardware, software versions, batch size, precision, sampling parameters, warm-up protocol, and statistical variation.
- Separate generator-only timing from tokenizer-and-decoder-inclusive end-to-end timing.
- Do not compare the best of many Tesserakt runs with an untuned single baseline without disclosure.
- Keep benchmark prompts and evaluation datasets separate from training and tuning.
- Publish negative findings, unstable runs, and limitations.
- Do not infer reasoning, general intelligence, or universal speed superiority from a narrow benchmark.

## 10. Engineering quality bar

Tesserakt is to be treated like **research software intended for other engineers**, not an ephemeral personal script.

**Required practices:**

1. **Version control discipline:** small reviewable commits, clear PRs, no unreviewed large rewrites.
2. **Testing:** unit tests for shapes, masks, quantization, losses, serialization; integration tests for mini-training and generate-after-reload; regression tests against reference outputs where feasible.
3. **Reproducible runs:** pinned dependencies, recorded seeds, dataset revisions, resolved config, Git commit, GPU/software info, and full run manifest.
4. **Numerical safety:** assertions for NaNs/Infs, gradient norms, codebook collapse, exploding memory, and invalid sample IDs.
5. **Observability:** structured metrics, useful failure messages, profiling, and checkpoints with recoverable optimizer/training state.
6. **Documentation:** concise architecture descriptions, math-to-code traceability, explicit known deviations from the paper, installation, how-to guides, and limitations.
7. **CI:** formatting, linting, type checking where practical, CPU smoke tests, dependency/license checks; GPU tests added as infrastructure permits.
8. **Security and data handling:** never commit credentials or private datasets; avoid unsafe deserialization of untrusted checkpoints; validate inputs and licenses.
9. **Responsible release:** document known failure modes, hallucinations, limitations, dataset scope, and intended research use.
10. **Honest project status:** distinguish `planned`, `experimental`, `working`, `validated`, and `released`. A feature is not complete just because its source file exists.

**Definition of done:** code + tests + reproducible experiment (when relevant) + documentation + measured result + clear limitations. No exceptions for agent-generated contributions.

## 11. Collaboration and AI-assisted development

AI coding agents may help implement, test, document, and review the framework, but **agent output is not evidence of correctness**. No claim is accepted without code inspection, targeted tests, and reproducible experiments. Automated agents must not silently alter scientific objectives, benchmark definitions, datasets, or checkpoint provenance to make results appear better.

Before significant changes, contributors should identify the hypothesis, affected module, baseline, test plan, and acceptance criteria. For risky research changes, implement the smallest independently verifiable step, preserve a reference path, and compare outputs. Avoid uncontrolled chains of speculative rewrites.

If tasks can be parallelized, module boundaries and interfaces must be explicit. One canonical specification governs tensor shapes, configuration formats, and checkpoint schemas. Prefer measured progress over the number of generated commits or files.

## 12. Governance, releases, and intellectual honesty

- Maintain visible issue/experiment tracking and a changelog for consequential research changes.
- Keep semantic versioning for stable public APIs once an API stability commitment is made; until then label experimental interfaces clearly.
- Credit original researchers and external contributors correctly; comply with licenses of code, pretrained weights, and datasets independently.
- Do not claim the first, fastest, smallest, state-of-the-art, or novel without a scoped review and evidence.
- Published model cards should state architecture, intended tasks, exact parameter counts (tokenizer / generator / total), dataset provenance, evaluation, limitations, and training resources.
- Prefer reproducibility and clarity to marketing language. Tesserakt's reputation should come from what others can verify.

## 13. Immediate execution checklist

- [ ] Create the repository with `IDEA.md`, an honest minimal `README.md`, and applicable licensing/attribution files.
- [ ] Pin the reference NCM commit, inspect the paper, and write a reference-to-Tesserakt implementation map.
- [ ] Run at least one official TinyStories checkpoint and save measured reference output and profiling data.
- [ ] Build a single modular monorepo (`src/tesserakt` framework + `recipes/language` models) with enforced one-way dependencies, configuration parsing, tests, and experiment manifests.
- [ ] Confirm tokenizer tensor contracts and implement a trainable tokenizer small enough for a tiny-set overfit test.
- [ ] Verify reconstruction metrics, codebook utilization, and checkpoint reload.
- [ ] Implement generator training faithful to the paper and a short unconditional sampling pipeline.
- [ ] Train a tiny end-to-end model and record its first reproducible held-out samples.
- [ ] Only then consolidate a documented `tesserakt tokenizer train`, `tesserakt train`, and `tesserakt generate` interface.
- [ ] Decide the next experiment from data, not intuition alone.

## 14. Success and failure criteria

**A successful first release** makes it possible for another developer to install Tesserakt, train a small tokenizer and NCM generator, restore a checkpoint, generate readable short text, and reproduce published evaluation results using documented commands. Quality may be limited; reproducibility must not be.

**A successful research program** determines whether and when compact NCM is competitive against honest baselines, publishes what worked and failed, and makes it easier for others to extend the architecture.

**Failure modes we will explicitly resist:** framework-first overengineering, misleading parameter counts, ignoring tokenizer decoding costs, cherry-picked samples, contaminated evaluations, untracked datasets, unsupported performance claims, half-working trainer code, and research decisions chosen merely to make a demo look impressive.

## 15. Founding principle

> **Build the smallest experiment that can tell us the truth. Make it reproducible. Improve it only when the evidence justifies the change.**

Tesserakt exists to explore whether hierarchical, parallel concept-code generation can become a practical foundation for compact language models—and to provide the tools needed to investigate that question rigorously.
