#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENCODE_CONFIG_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
VAULT_DIR="${VAULT_DIR:-$HOME/jarvis-vault}"
OLLAMA_BASE_URL="${OLLAMA_BASE_URL:-http://ollama.lan:11434/v1}"
TODAY="$(date +%F)"

render() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  sed \
    -e "s|{{VAULT_DIR}}|$VAULT_DIR|g" \
    -e "s|{{OPENCODE_CONFIG}}|$OPENCODE_CONFIG_DIR/opencode.json|g" \
    -e "s|{{OLLAMA_BASE_URL}}|$OLLAMA_BASE_URL|g" \
    -e "s|{{DATE}}|$TODAY|g" \
    "$src" > "$dest"
}

backup_if_exists() {
  local file="$1"
  if [ -f "$file" ]; then
    cp "$file" "$file.backup.$(date +%Y%m%d-%H%M%S)"
  fi
}

mkdir -p "$OPENCODE_CONFIG_DIR/plugins"
mkdir -p \
  "$VAULT_DIR/_facts" \
  "$VAULT_DIR/_memories" \
  "$VAULT_DIR/_sessions" \
  "$VAULT_DIR/_code_memory/fixes" \
  "$VAULT_DIR/_code_memory/patterns" \
  "$VAULT_DIR/_code_memory/failures" \
  "$VAULT_DIR/_code_memory/projects" \
  "$VAULT_DIR/_code_memory/pending"

backup_if_exists "$OPENCODE_CONFIG_DIR/opencode.json"
render "$REPO_DIR/templates/opencode/opencode.json.template" "$OPENCODE_CONFIG_DIR/opencode.json"
render "$REPO_DIR/templates/opencode/code-memory-auto.js.template" "$OPENCODE_CONFIG_DIR/plugins/code-memory-auto.js"

render "$REPO_DIR/templates/vault/OpenCode Memory.md" "$VAULT_DIR/OpenCode Memory.md"
render "$REPO_DIR/templates/vault/_sessions/CURRENT.md" "$VAULT_DIR/_sessions/CURRENT.md"
render "$REPO_DIR/templates/vault/_code_memory/README.md" "$VAULT_DIR/_code_memory/README.md"
render "$REPO_DIR/templates/vault/_code_memory/patterns/opencode-global-code-memory.md" "$VAULT_DIR/_code_memory/patterns/opencode-global-code-memory.md"

if ! grep -q "opencode-portable-setup helpers" "$HOME/.bashrc" 2>/dev/null; then
  cat "$REPO_DIR/scripts/shell-helpers.sh" >> "$HOME/.bashrc"
fi

printf 'Installed OpenCode setup.\n'
printf 'Config: %s\n' "$OPENCODE_CONFIG_DIR/opencode.json"
printf 'Vault: %s\n' "$VAULT_DIR"
printf 'Restart your terminal and OpenCode.\n'

