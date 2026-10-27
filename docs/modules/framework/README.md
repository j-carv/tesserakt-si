---
title: Tesserakt Framework
summary: Current Python package and planned reusable research components.
status: active
owners: []
updated: 2026-10-27
related: [../../architecture/overview.md, ../language/README.md]
---

# Tesserakt Framework

## Responsibility

The framework is the intended home for reusable tokenizer, generator, data, training, evaluation, inference, and CLI capabilities. It must not depend on a particular language recipe, dataset, or checkpoint; see the [architecture overview](../../architecture/overview.md).

## Current state and interface

[`src/tesserakt/__init__.py`](../../../src/tesserakt/__init__.py) contains a package docstring only. The existing [smoke test](../../../tests/test_package.py) checks that `tesserakt` imports. No model, training, inference, or CLI API is implemented. Any future public interfaces and contracts require specifications before implementation.

## Ownership

No module owner has been assigned.
