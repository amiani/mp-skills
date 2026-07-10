#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
ADAPTER="$ROOT/skills/misc/adapt-matt-pocock-skills"
FAILED=0

fail() {
  echo "FAIL: $*" >&2
  FAILED=1
}

[[ "$(git branch --show-current)" == "amiani/artifact-workspaces" ]] || \
  fail "expected branch amiani/artifact-workspaces"
git remote get-url upstream >/dev/null 2>&1 || fail "missing upstream remote"
git cat-file -e "$(cat "$ADAPTER/UPSTREAM-BASE")^{commit}" 2>/dev/null || \
  fail "UPSTREAM-BASE is not a known commit"

while IFS= read -r name; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  count="$(find "$ROOT/skills" -name SKILL.md -not -path '*/deprecated/*' \
    -exec dirname {} \; | awk -F/ -v name="$name" '$NF == name { count++ } END { print count+0 }')"
  [[ "$count" == 1 ]] || fail "manifest skill '$name' resolved $count times"
done < "$ADAPTER/INSTALL-MANIFEST.txt"

for file in \
  skills/productivity/teach/SKILL.md \
  skills/engineering/domain-modeling/SKILL.md \
  skills/engineering/setup-matt-pocock-skills/SKILL.md \
  skills/engineering/research/SKILL.md \
  skills/engineering/to-tickets/SKILL.md \
  skills/engineering/triage/SKILL.md; do
  rg -q 'Artifact routing|artifact route|agent workspace|configured.*route|configured.*location' \
    "$ROOT/$file" || fail "$file has no visible routing adaptation"
done

skill_lines="$(wc -l < "$ADAPTER/SKILL.md" | tr -d ' ')"
(( skill_lines <= 100 )) || fail "adapter SKILL.md exceeds 100 lines ($skill_lines)"

git -C "$ROOT" diff --check || fail "working-tree diff check failed"
if git show-ref --verify --quiet refs/remotes/upstream/main; then
  git -C "$ROOT" diff --check upstream/main...HEAD || \
    fail "branch diff check failed"
fi

audit="$(mktemp)"
trap 'rm -f "$audit"' EXIT
"$ADAPTER/scripts/audit-locations.sh" "$audit" >/dev/null
echo "audit candidates: $(grep -vc '^#\|^$' "$audit" || true)"

if (( FAILED )); then
  exit 1
fi
echo "adaptation verification passed"
