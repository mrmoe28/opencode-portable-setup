
# opencode-portable-setup helpers
export PATH="$HOME/.opencode/bin:$HOME/.npm-packages/bin:$HOME/go/bin:$PATH"
export OLLAMA_HOST="${OLLAMA_HOST:-{{OLLAMA_HOST}}}"
export OLLAMA_BASE_URL="${OLLAMA_BASE_URL:-{{OLLAMA_HOST}}}"

oc() {
  OLLAMA_HOST="$OLLAMA_HOST" OLLAMA_BASE_URL="$OLLAMA_BASE_URL" opencode "$@"
}

ocr() {
  OLLAMA_HOST="$OLLAMA_HOST" OLLAMA_BASE_URL="$OLLAMA_BASE_URL" opencode --continue "$@"
}

_agent_pick_work_mode() {
  local prompt="${*,,}"
  case "$prompt" in
    *database*|*migration*|*supabase*|*postgres*|*sql*|*webhook*|*api*|*integration*|*deploy*|*production*|*auth*|*security*|*payment*|*stripe*|*architecture*|*refactor*|*multi-file*|*multiple\ files*|*logic*|*reason*|*analyze*|*trace*|*investigate*|*entire\ repo*|*whole\ repo*|*audit*|*review*|*debug*|*fix*|*implement*|*add\ feature*|*tests*|*test\ suite*|*browser*|*playwright*|*failing*|*error*|*bug*|*broken*)
      printf '%s\n' "careful"
      ;;
    *)
      printf '%s\n' "direct"
      ;;
  esac
}

_agent_mode_prompt() {
  case "$1" in
    careful)
      cat <<'EOF'
Work mode: careful coding.
- Inspect the relevant files before editing.
- Think through the likely cause and choose the smallest safe fix.
- Prefer existing project patterns.
- Verify with focused tests or commands when possible.
- Update persistent code memory when the fix teaches something reusable.
EOF
      ;;
    *)
      cat <<'EOF'
Work mode: direct coding.
- Make the requested change with minimal ceremony.
- Keep edits narrowly scoped.
- Verify only as much as the change warrants.
EOF
      ;;
  esac
}

agent-auto() {
  local prompt="$*"
  if [ -z "$prompt" ]; then
    printf 'Task: '
    read -r prompt
  fi

  local work_mode
  work_mode="$(_agent_pick_work_mode "$prompt")"
  printf 'Using ollama/glm-4.7:cloud [%s]\n' "$work_mode"
  OLLAMA_HOST="$OLLAMA_HOST" OLLAMA_BASE_URL="$OLLAMA_BASE_URL" opencode run --model ollama/glm-4.7:cloud "$(_agent_mode_prompt "$work_mode")

User task:
$prompt"
}
