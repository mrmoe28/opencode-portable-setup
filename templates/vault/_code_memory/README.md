# Global Code Memory

This folder is OpenCode's global coding knowledge base.

It is not model training. It is persistent retrieval memory: OpenCode should read these notes at session start and before similar work, then update them after useful fixes or failed approaches.

## Folders

- `fixes/`: specific bugs fixed, root causes, files changed, and verification.
- `patterns/`: reusable implementation patterns that worked across projects.
- `failures/`: approaches that did not work, with symptoms and safer alternatives.
- `projects/`: project-specific conventions, architecture notes, commands, and traps.
- `pending/`: automatically generated notes that should be reviewed and converted.

## Update Rules

- Keep entries short and factual.
- Prefer pointers to repo files, commits, tests, or commands over copying large code.
- Record both what worked and what failed.
- Do not store secrets, tokens, passwords, private keys, or customer data.
- When a new fix resembles an old one, update the existing note instead of duplicating it.
- Check `pending/` at session start and convert useful entries into durable `fixes`, `patterns`, or `failures`.

## Entry Template

```md
# Fix or Pattern: short name

Date: YYYY-MM-DD
Project: /absolute/project/path
Stack: language/framework/runtime
Status: worked | failed | partial

## Problem

What was broken or needed.

## Cause

The root cause or key constraint.

## Action

What changed or what approach was tried.

## Verification

Commands, tests, screenshots, or manual checks.

## Reuse Notes

When to apply this again, and when not to.
```

