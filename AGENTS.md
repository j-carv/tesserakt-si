# Agent instructions

Tesserakt is research infrastructure for Next-Concept Modeling, not yet a working NCM model or baseline. `IDEA.md` is the authoritative project vision: read its relevant sections before changing behavior and do not edit it without explicit direction. Treat its architecture and milestones as plans, not existing capabilities. Start with [the documentation index](docs/DOCUMENTATION.md), [progress](docs/PROGRESS.md), and [plan](PLAN.md).

## Commands

From the repository root: install locked dependencies with `uv sync --locked`; run tests with `uv run pytest`, lint with `uv run ruff check .`, and check formatting with `uv run ruff format --check .`. There is no model training or inference command yet. Python 3.12 is pinned in `.python-version`; PyTorch is planned, not currently a project dependency.

## Spec-driven development

- Features, behavioral changes and public contract changes require a spec at `docs/specs/<module>/<feature>.md` approved by the user before implementation. Define the problem, scope, requirements, acceptance criteria, design, interfaces and relevant scientific assumptions. Use the existing spec template in `docs/templates/`.
- Flow: approved spec → design and tasks → implementation → verification against each acceptance criterion → spec status `implemented`. Tests for new acceptance criteria reference their `AC-n` IDs. If implementation must diverge, update the spec first; obtain user approval for behavioral changes.
- For pre-adoption code, the first behavior or contract change documents current behavior from code and tests, citing files, before requirements for the scoped change. Existing tests need not be renamed. Bug fixes and behavior-preserving refactors do not require a new spec, but must respect existing specs.
- Inspect existing code and tests and implement the smallest complete end-to-end vertical slice. Resolve ambiguity against `IDEA.md` and existing contracts; never invent functionality.

## Architecture and science

- Reusable framework code in `src/tesserakt` must not depend on language recipes, datasets, checkpoint IDs, or model-specific configurations. Recipes depend on framework interfaces, never the reverse. Respect module boundaries and specify public contract changes first; avoid central registries that become shared hot files.
- Preserve reference fidelity and attribution; verify licensing before copying external code. Distinguish reproduction, adaptation, and novel research.
- Learned concept codes are not guaranteed human-interpretable concepts. Do not claim general superiority or speedups without controlled evidence. Report generator and tokenizer/decoder costs separately and compare full end-to-end resources.
- Do not fabricate models, training results, benchmarks, datasets, or working commands. Record experimental methods and evidence rather than presenting hypotheses as results. Reproducibility, data provenance, split hygiene, and measured hardware feasibility matter.
- Git LFS is only for artifacts explicitly selected for publication; do not commit datasets, checkpoints, generated graphs, or local secrets by default.

## Documentation and collaboration

- Update tests and relevant documentation alongside behavior. Update the touched module's section in `docs/PROGRESS.md` when a task changes status, link new documentation from `docs/DOCUMENTATION.md`, and record architectural decisions in dated ADRs. Keep plans current when scope, milestones or ordering change.
- Every user-visible change requires a `changelog.d/YYYYMMDD-<module>-<slug>.md` fragment with `type`, `module`, and `ref` frontmatter and a user-facing sentence. Mark breaking changes and describe migration. Internal-only refactors, tests, tooling and documentation need no fragment. Edit `CHANGELOG.md` only during a release.
- Use short branches and small PRs. Independent tasks may run in parallel across separate modules with explicit interfaces; avoid conflicts in shared files. Never commit generated files or build output.

## Graphify

Graphify is an optional local CLI and MCP aid for code exploration only. Index source code only, without a semantic pass over documents or data; keep generated graphs local and ignored. Consult the installed Graphify documentation for supported code-only commands and configuration rather than assuming a CLI or MCP invocation. Confirm graph findings in source; fall back to direct search if unavailable or stale.

## Specialized agents

- `researcher`: obtain primary-source evidence, assess reference behavior, requirements, feasibility, licenses and scientific uncertainty before a spec or ADR when external evidence is needed. Record research and link it in the documentation index.
- `implementer`: focused S tasks or single-module M tasks with clear acceptance criteria and an existing pattern.
- `implementer-complex`: cross-module or public-contract changes, new patterns, concurrency, performance, security-sensitive work, larger tasks, or escalation after repeated implementation/review failure.
- `reviewer`: read-only review after implementation and before a commit or PR; check the spec, tests, architecture, science and documentation. Resolve blockers and review again before committing.

For behavior or contract changes, the workflow is researcher when needed → user-approved spec → appropriate implementer → reviewer → main agent commits. Route independent tasks to separate implementers only when their ownership and contracts avoid conflicts.

## Skills and mirrors

Agent definitions and skills are canonical under `.claude/` and copied to `.agents/`, including supporting files; sync additions, changes and deletions with `sh scripts/sync-agents.sh` or `powershell -File scripts/sync-agents.ps1`. CI checks with `sh scripts/sync-agents.sh --check`. The platform-generated `skills/graphify/` directories are the sole mirror exception and must remain independent. Update affected agents whenever stack, commands, modules or boundaries change. Shared instructions belong here; `CLAUDE.md` imports this file and repeats the commit rule.

## Commit messages

Write commits in English. Use an imperative first line of at most 200 characters, then a blank line and a body explaining, in order: what was done, why, how it works, expected behavior, and how to test. Do not add mentions unless requested. If the reason is unclear, ask before committing.
