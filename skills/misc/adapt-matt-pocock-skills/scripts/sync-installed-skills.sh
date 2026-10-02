#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
ADAPTER="$ROOT/skills/misc/adapt-matt-pocock-skills"
MANIFEST="$ADAPTER/INSTALL-MANIFEST.txt"
LEGACY="$ADAPTER/LEGACY-MANIFEST.txt"
AGENTS_DEST="$HOME/.agents/skills"
CLAUDE_DEST="$HOME/.claude/skills"
PI_DEST="$HOME/.pi/agent/skills"
STATE_DIR="$HOME/.local/state/mp-skills"
STATE_MANIFEST="$STATE_DIR/installed-skills.txt"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$STATE_DIR/backups/$STAMP"

mkdir -p "$AGENTS_DEST" "$CLAUDE_DEST" "$PI_DEST" "$STATE_DIR" "$BACKUP"

read_manifest() {
  awk 'NF && $1 !~ /^#/ { print $1 }' "$1" | LC_ALL=C sort -u
}

backup_target() {
  local target="$1" bucket="$2" name
  [[ -e "$target" || -L "$target" ]] || return 0
  name="$(basename "$target")"
  mkdir -p "$BACKUP/$bucket"
  mv "$target" "$BACKUP/$bucket/$name"
}

source_for() {
  local name="$1" found=()
  while IFS= read -r path; do found+=("$path"); done < <(
    find "$ROOT/skills" -name SKILL.md -not -path '*/deprecated/*' \
      -exec dirname {} \; | awk -F/ -v name="$name" '$NF == name'
  )
  [[ ${#found[@]} -eq 1 ]] || {
    echo "error: '$name' resolved to ${#found[@]} skill directories" >&2
    return 1
  }
  printf '%s\n' "${found[0]}"
}

current="$(mktemp)"
previous="$(mktemp)"
trap 'rm -f "$current" "$previous"' EXIT
read_manifest "$MANIFEST" > "$current"
if [[ -f "$STATE_MANIFEST" ]]; then
  read_manifest "$STATE_MANIFEST" > "$previous"
else
  : > "$previous"
fi

# Remove previously managed skills that disappeared from the manifest.
comm -23 "$previous" "$current" | while IFS= read -r name; do
  target="$AGENTS_DEST/$name"
  if [[ -L "$target" && "$(readlink "$target")" == "$ROOT"/* ]]; then rm "$target"; fi
  if [[ -L "$CLAUDE_DEST/$name" ]]; then rm "$CLAUDE_DEST/$name"; fi
  if [[ -L "$PI_DEST/$name" ]]; then rm "$PI_DEST/$name"; fi
done

# Migrate known pre-v1.1 names without touching unrelated personal skills.
while IFS= read -r name; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  backup_target "$AGENTS_DEST/$name" agents
  backup_target "$CLAUDE_DEST/$name" claude
  backup_target "$PI_DEST/$name" pi
done < "$LEGACY"

while IFS= read -r name; do
  source="$(source_for "$name")"
  target="$AGENTS_DEST/$name"
  if [[ ! -L "$target" || "$(readlink "$target")" != "$source" ]]; then
    backup_target "$target" agents
    ln -s "$source" "$target"
  fi

  # Claude consumes the shared Agent Skills installation through a second link.
  target="$CLAUDE_DEST/$name"
  if [[ ! -L "$target" || "$(readlink "$target")" != "$AGENTS_DEST/$name" ]]; then
    backup_target "$target" claude
    ln -s "$AGENTS_DEST/$name" "$target"
  fi

  # Pi discovers ~/.agents/skills directly. Remove only redundant links.
  target="$PI_DEST/$name"
  if [[ -L "$target" ]]; then
    resolved="$(readlink "$target")"
    case "$resolved" in
      *".agents/skills/$name"|"$source") rm "$target" ;;
    esac
  fi
done < "$current"

cp "$current" "$STATE_MANIFEST"
rmdir "$BACKUP/pi" "$BACKUP/claude" "$BACKUP/agents" "$BACKUP" 2>/dev/null || true
echo "synchronized $(wc -l < "$current" | tr -d ' ') skills"
echo "state: $STATE_MANIFEST"
if [[ -d "$BACKUP" ]]; then
  echo "replaced entries backed up under: $BACKUP"
fi
