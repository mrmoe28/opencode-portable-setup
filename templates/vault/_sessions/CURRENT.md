# Current OpenCode Session State

Updated: {{DATE}}

## Active Setup

- OpenCode global config: `{{OPENCODE_CONFIG}}`
- Persistent memory root: `{{VAULT_DIR}}`
- OpenCode loads this file on startup through the global `instructions` list.
- LSP is enabled globally with `"lsp": true`.

## Resume Notes

- To resume the last OpenCode conversation, start OpenCode with `opencode --continue`.
- To resume a specific session, use `opencode --session <sessionID>`.
- To see saved sessions, use `opencode session list`.

## Next Steps

- Restart OpenCode after config or PATH changes so it reloads memory, LSP settings, and shell environment.
- Keep this file short and update it at the end of meaningful OpenCode work.

