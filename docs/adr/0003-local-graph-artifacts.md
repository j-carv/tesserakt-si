---
title: Local code graph and explicit artifact tracking
summary: Keep generated graphs local and track published artifacts deliberately.
status: active
owners: []
updated: 2026-10-27
related: [../guides/setup.md]
---

# ADR 0003: Local code graph and explicit artifact tracking

- **Status:** Accepted
- **Context:** Contributors may benefit from code navigation without committing generated graphs or implicitly storing large research artifacts in Git.
- **Decision:** Graphify is optional and local, using its CLI and local MCP server for code-only graphs. Generated graph output is ignored. Git LFS is optional and applies only to artifacts explicitly selected for publication, not to all checkpoints or datasets.
- **Consequences:** Contributors install and configure their own tools; a graph must be regenerated locally. Before publishing an artifact, review licensing, provenance, size, and hosting costs and explicitly configure its LFS path. Never commit private data or credentials.
- **Sources:** [Graphify CLI reference](https://docs.graphify.com/reference/overview), [local MCP setup](https://docs.graphify.com/mcp/overview), [Git LFS documentation](https://git-lfs.com/).
