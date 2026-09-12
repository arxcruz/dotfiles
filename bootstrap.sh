#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="${HOME}/.config/dotfiles"
STATE_FILE="${STATE_DIR}/playbook"

cd "$REPO_DIR"

unattended=false
playbook_arg=""

for arg in "$@"; do
  case "$arg" in
    --unattended|--cron)
      unattended=true
      ;;
    *.yml)
      playbook_arg="$arg"
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

if [ ! -t 0 ]; then
  unattended=true
fi

list_playbooks() {
  find "$REPO_DIR" -maxdepth 1 -name '*.yml' -printf '%f\n' | sort
}

choose_playbook() {
  echo "Available playbooks:"
  local playbooks=()
  while IFS= read -r p; do
    playbooks+=("$p")
  done < <(list_playbooks)

  select chosen in "${playbooks[@]}"; do
    if [ -n "${chosen:-}" ]; then
      echo "$chosen"
      return 0
    fi
    echo "Invalid choice, try again." >&2
  done
}

playbook=""

if [ -n "$playbook_arg" ]; then
  playbook="$playbook_arg"
elif [ -f "$STATE_FILE" ]; then
  playbook="$(cat "$STATE_FILE")"
elif [ "$unattended" = true ]; then
  echo "No playbook selected yet. Run this script interactively once to choose one." >&2
  exit 1
else
  playbook="$(choose_playbook)"
fi

if [ ! -f "$REPO_DIR/$playbook" ]; then
  echo "Playbook not found: $playbook" >&2
  exit 1
fi

mkdir -p "$STATE_DIR"
echo "$playbook" > "$STATE_FILE"

echo "Updating dotfiles repository..."
git -C "$REPO_DIR" pull --ff-only

echo "Running $playbook (unattended: $unattended)..."

if [ "$unattended" = true ]; then
  ansible-playbook "$playbook" --skip-tags privileged
else
  ansible-playbook "$playbook" --ask-become-pass
fi
