# Tesserakt

Research-first infrastructure for exploring [Next-Concept Modeling](https://arxiv.org/abs/2610.14162) (NCM). The project is guided by [IDEA.md](IDEA.md).

**Status: foundation only.** The official NCM baseline has not been reproduced; no trained model, training pipeline, benchmark results, or generation capability is claimed. Tesserakt Language is a research goal, not a released model.

The initial monorepo separates reusable Python/PyTorch framework code from model-specific recipes. Reference fidelity and reproducibility come before architectural changes or performance claims. See the [architecture overview](docs/architecture/overview.md) and [progress](docs/PROGRESS.md).

## Getting started

Install [uv](https://docs.astral.sh/uv/getting-started/installation/) and use the project's supported Python version specified in `pyproject.toml`:

```sh
uv sync
uv run pytest
uv run ruff check .
uv run ruff format --check .
```

See [setup](docs/guides/setup.md) for optional local Graphify and Git LFS configuration. These are development checks, not a model reproduction.

## Documentation and contributions

Start with the [documentation index](docs/DOCUMENTATION.md), then read [contributing](CONTRIBUTING.md). Changes are recorded in the [changelog](CHANGELOG.md). The project is licensed under [MIT](LICENSE), copyright Tesserakt SI.

## Research attribution

NCM is due to Kumbong et al., [*Next-Concept Modeling: Fast, Parallel Coarse-to-Fine Text Generation*](https://arxiv.org/abs/2610.14162). Consult the [official reference implementation](https://github.com/HazyResearch/ncm), its current license, and the [research overview](https://hazyresearch.stanford.edu/blog/2026-10-12-ncm). Learned codes are latent representations, not guaranteed human-readable concepts; published performance comparisons do not establish a general advantage over autoregressive models.
