# Contributing

Tesserakt is research software. Contributions must be understandable, reproducible where applicable, and maintainable by someone who did not write them. Read [IDEA.md](IDEA.md), [the architecture](docs/architecture/overview.md), and [the documentation index](docs/DOCUMENTATION.md) before proposing a substantial change.

## Before opening a pull request

- For substantial work, open an issue first describing the problem, evidence, scope, and proposed approach. Discuss changes to research objectives, public contracts, dependencies, or architecture before implementing them.
- Features, behavioral changes, and public contract changes require an approved [specification](docs/templates/spec.md) with acceptance criteria. Significant architectural decisions need an [ADR](docs/templates/adr.md).
- Keep each pull request focused and reviewable. Do not bundle unrelated refactors, generated artifacts, or formatting changes.
- You are responsible for understanding and explaining every change you submit, including AI-generated code. We will not accept a PR whose author cannot explain its purpose, implementation, verification, and relevant limitations, or that contains unsupported claims, unexplained changes, or unreviewed generated output. AI assistance is permitted; it does not replace author accountability or review.
- Be respectful. Reviewers may request changes or close proposals that lack sufficient context, fall outside scope, or cannot be maintained safely.

## Environment and checks

Follow the [setup guide](docs/guides/setup.md), including the ordering of Git LFS and Graphify hooks. Install Git LFS when handling explicitly published artifacts. From the repository root:

```sh
uv sync --locked
uv run pytest
uv run ruff check .
uv run ruff format --check .
sh scripts/sync-agents.sh --check
```

Describe the checks actually run and their results. Add deterministic tests for consumer-visible behavior and edge cases; do not claim an experiment was reproduced unless it was run. Explain unrun checks and blockers. Hardware-dependent results must record hardware, software versions, seeds, data revisions, configuration, and relevant resource measurements.

## Pull request requirements

Use the pull request template and fill every section with specific information. Link the issue or approved spec; explain the change and why it is correct; provide verification results; state research, data, licensing, documentation, and compatibility impacts. If a section does not apply, explain why. Passing automated checks does not imply acceptance: maintainers review the substance and may request changes. A maintainer approval and passing required checks are required before merging into `main`.

Keep framework code independent of model-specific recipes. Verify and preserve third-party attribution and license notices; check source code, datasets, and checkpoint terms separately. Never commit credentials, private data, local graphs, or unapproved model artifacts. Record data provenance and prevent train/evaluation contamination. Do not advertise scientific novelty, speedups, or model capabilities without appropriately scoped evidence.

## Documentation and changelog

Update the relevant documentation and `docs/PROGRESS.md`. Add one `changelog.d/YYYYMMDD-<module>-<slug>.md` fragment for a user-visible change; internal-only changes do not require one. Do not edit `CHANGELOG.md` except during a release. Keep `.claude/` and `.agents/` project agents and skills synchronized with the provided scripts; Graphify's platform-generated skills are the exception.

## Git workflow

Use short branches and focused pull requests. Commit messages are written in Portuguese (pt-BR): an imperative summary followed by a body covering what, why, how, expected behavior, and verification. Never include an @mention unless explicitly requested. See [AGENTS.md](AGENTS.md) for the complete rule.
