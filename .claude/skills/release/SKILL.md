---
name: release
description: Prepare an evidence-based Tesserakt release and compile changelog fragments.
---

# Release

1. Read `AGENTS.md`, `IDEA.md`, and applicable documentation. List `changelog.d/*.md`; if there are no fragments, stop and report it.
2. Choose a version using Semantic Versioning: breaking changes bump major (minor before 1.0), additions bump minor, other changes bump patch. Ask the user to confirm the version and release scope.
3. Verify changes, attribution, dependency and dataset licenses, reproducibility, and whether artifacts are authorized for publication. Model releases must report measured generator and tokenizer/decoder sizes, methods, limitations, and end-to-end costs. Never claim planned functionality is shipped.
4. Run applicable checks including `uv sync --locked`, `uv run pytest`, `uv run ruff check .`, `uv run ruff format --check .`, and `sh scripts/sync-agents.sh --check`; report failures and blockers.
5. After approval, compile fragments into a dated version section of `CHANGELOG.md`, grouped as Added, Changed, Deprecated, Removed, Fixed, Security. Include the module and reference. Remove only compiled fragments, preserve `.gitkeep`, and update the package version and progress.
6. Commit using the project commit rule, then create an annotated `v<version>` tag only when the user explicitly authorizes it. Push or publish only when requested.
