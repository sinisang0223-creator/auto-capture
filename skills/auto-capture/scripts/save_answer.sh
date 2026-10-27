#!/bin/bash
# Append an answer (read from stdin) to today's log and copy it to the clipboard.
# Usage: save_answer.sh "<short title>" <<'CLAUDE_ANSWER_END' ... CLAUDE_ANSWER_END
set -euo pipefail

title="${1:-}"
dir="${CLAUDE_ANSWERS_DIR:-$PWD/claude-answers}"
mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d).md"
answer="$(cat)"

if [ ! -s "$file" ]; then
  printf '# Claude answers — %s\n' "$(date +%Y-%m-%d)" > "$file"
fi
{
  printf '\n---\n\n## %s · %s\n\n' "$(date +%H:%M)" "$title"
  printf '%s\n' "$answer"
} >> "$file"

copied="no clipboard tool found"
if command -v pbcopy >/dev/null 2>&1; then          # macOS
  printf '%s' "$answer" | pbcopy && copied="copied"
elif command -v clip.exe >/dev/null 2>&1; then      # Windows (Git Bash / WSL)
  printf '%s' "$answer" | clip.exe && copied="copied"
elif command -v wl-copy >/dev/null 2>&1; then       # Linux, Wayland
  printf '%s' "$answer" | wl-copy && copied="copied"
elif command -v xclip >/dev/null 2>&1; then         # Linux, X11
  printf '%s' "$answer" | xclip -selection clipboard && copied="copied"
fi

echo "saved: $file ($copied)"
