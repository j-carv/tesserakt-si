---
title: Setup
summary: Install development tools and configure local hooks.
status: active
owners: [contributors]
updated: 2026-10-27
related: [testing.md, development.md]
---

# Setup

Install Git, a Python version supported by `pyproject.toml`, and [uv](https://docs.astral.sh/uv/getting-started/installation/). From the repository root:

```sh
uv sync
```

See [testing](testing.md) for checks. PyTorch hardware support depends on the installed build and device; no particular accelerator or training feasibility is promised.

## Optional: local code graph

Install [Git LFS](https://git-lfs.com/) and [Graphify](https://docs.graphify.com/installation), then install the LFS hooks **before** the Graphify hooks in a fresh clone:

```sh
git lfs install --local
uv tool install "graphifyy[mcp]"
graphify extract . --code-only
graphify cluster-only . --no-label
graphify hook install
```

After pulling changes, run `graphify update .` to refresh the local code graph.

Git hooks are local and not versioned. If Graphify hooks are already present, `git lfs install --local` may refuse to overwrite them. Do not use `--force`: run `git lfs update --manual` and add its commands to the corresponding existing hooks, preserving both tools. Check that `pre-push`, `post-checkout`, `post-commit`, and `post-merge` contain the LFS commands and that Graphify's existing blocks remain intact. After updating either tool, verify the hooks again.

Configure a compatible MCP client to run `graphify-mcp` with the **absolute path** to `graphify-out/graph.json` as its argument. For example, with Codex:

```sh
codex mcp add graphify -- graphify-mcp /absolute/path/to/tesserakt/graphify-out/graph.json
```

Replace the example path with your actual path. See the [local MCP instructions](https://docs.graphify.com/mcp/overview) and [CLI reference](https://docs.graphify.com/reference/overview); installed versions may differ. Graphs are local generated artifacts, not source or a substitute for reading code. Do not include documents, datasets, secrets, or model artifacts in the graph.

## Optional: explicitly published artifacts

[Git LFS](https://git-lfs.com/) is not required for ordinary development. Install Git LFS and run `git lfs install` before publishing. Files deliberately placed under `releases/artifacts/` are configured for LFS; model files elsewhere remain ignored. Review each artifact's license, provenance, size, and remote hosting quota before adding it. Do not track datasets or checkpoints by default.
