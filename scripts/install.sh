#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENCODE_CONFIG_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
VAULT_DIR="${VAULT_DIR:-$HOME/jarvis-vault}"
OLLAMA_BASE_URL="${OLLAMA_BASE_URL:-http://ollama.lan:11434/v1}"
TODAY="$(date +%F)"

usage() {
  cat <<'EOF'
Usage: ./scripts/install.sh [options]

Options:
  --vault-dir PATH          Persistent memory vault path.
  --ollama-url URL          Ollama OpenAI-compatible API base URL, usually http://SERVER:11434/v1.
  --ollama-host URL         Ollama host URL without /v1, usually http://SERVER:11434.
  -h, --help                Show this help.

Environment variables:
  VAULT_DIR                 Same as --vault-dir.
  OLLAMA_BASE_URL           Same as --ollama-url.
  OLLAMA_HOST               Same as --ollama-host.

Examples:
  ./scripts/install.sh
  ./scripts/install.sh --ollama-host http://ollama.lan:11434
  ./scripts/install.sh --ollama-url http://192.168.1.25:11434/v1
  VAULT_DIR="$HOME/Project X/jarvis-vault" ./scripts/install.sh --ollama-host http://ollama.lan:11434
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --vault-dir)
      VAULT_DIR="${2:?Missing value for --vault-dir}"
      shift 2
      ;;
    --ollama-url|--ollama-base-url)
      OLLAMA_BASE_URL="${2:?Missing value for --ollama-url}"
      shift 2
      ;;
    --ollama-host)
      OLLAMA_HOST="${2:?Missing value for --ollama-host}"
      OLLAMA_BASE_URL="${OLLAMA_HOST%/}/v1"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

OLLAMA_HOST="${OLLAMA_HOST:-${OLLAMA_BASE_URL%/v1}}"

render() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  sed \
    -e "s|{{VAULT_DIR}}|$VAULT_DIR|g" \
    -e "s|{{OPENCODE_CONFIG}}|$OPENCODE_CONFIG_DIR/opencode.json|g" \
    -e "s|{{OLLAMA_BASE_URL}}|$OLLAMA_BASE_URL|g" \
    -e "s|{{OLLAMA_HOST}}|$OLLAMA_HOST|g" \
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
render "$REPO_DIR/scripts/shell-helpers.sh" "$HOME/.opencode-portable-shell-helpers"

if ! grep -q "opencode-portable-setup helpers" "$HOME/.bashrc" 2>/dev/null; then
  {
    printf '\n# opencode-portable-setup helpers\n'
    printf '. "$HOME/.opencode-portable-shell-helpers"\n'
  } >> "$HOME/.bashrc"
fi

printf 'Installed OpenCode setup.\n'
printf 'Config: %s\n' "$OPENCODE_CONFIG_DIR/opencode.json"
printf 'Vault: %s\n' "$VAULT_DIR"
printf 'Ollama host: %s\n' "$OLLAMA_HOST"
printf 'Ollama API base URL: %s\n' "$OLLAMA_BASE_URL"
printf 'Restart your terminal and OpenCode.\n'
