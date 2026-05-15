# OpenCode Memory

This note is loaded into OpenCode sessions as persistent memory.

## How To Use This Vault

- Treat this vault as long-term user, project, and coding memory.
- Read this file first when a session starts.
- When a task depends on prior context, inspect relevant Markdown files in this vault before making assumptions.
- Do not print secrets or private credentials from this vault.
- Do not rewrite or reorganize the vault unless explicitly asked.

## Important Paths

- Vault root: `{{VAULT_DIR}}`
- Structured facts: `{{VAULT_DIR}}/_facts`
- Saved memories: `{{VAULT_DIR}}/_memories`
- Session notes: `{{VAULT_DIR}}/_sessions`
- Global code memory: `{{VAULT_DIR}}/_code_memory`

## Memory Workflow

- At session start, read `_sessions/CURRENT.md` as the active handoff before starting work.
- For coding tasks, consult `_code_memory/README.md` and relevant notes under `_code_memory` before making assumptions.
- When a session reaches a useful stopping point, update `_sessions/CURRENT.md` with the active goal, relevant files, decisions, blockers, and next steps.
- After fixing a coding problem, add or update a concise note in `_code_memory/fixes/` with the problem, cause, action, verification, and reuse notes.
- After discovering a reusable coding approach, add or update `_code_memory/patterns/`.
- After an approach fails in a useful way, add or update `_code_memory/failures/` so future sessions avoid repeating it.
- If `_code_memory/pending/` contains notes, review them at session start and convert useful entries into `fixes`, `patterns`, or `failures`.
- Keep memory entries short, dated, and factual.
- Prefer linking to project files instead of copying large source code into the vault.
- If a memory conflicts with the current repo or current user request, ask for clarification.

## Coding Work Mode

- Use careful mode automatically for debugging, failing tests, multi-file edits, refactors, architecture, auth, database, deployment, production, security, payments, browser automation, or unclear root-cause work.
- In careful mode, inspect relevant files before editing, reason through the likely cause, make the smallest safe fix, verify with focused commands, and update code memory if the result is reusable.
- Use direct mode for simple one-file edits, wording changes, small styling tweaks, basic explanations, or straightforward commands.
- In direct mode, keep the work minimal and avoid unnecessary planning.

