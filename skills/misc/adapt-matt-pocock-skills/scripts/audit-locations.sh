#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
OUTPUT="${1:-/dev/stdout}"

cd "$ROOT"

PATTERN='current (working )?directory|repo(sitory)? root|project root|root of|CONTEXT(-MAP)?\.md|docs/adr|docs/agents|\.scratch|\.out-of-scope|tickets\.md|MISSION\.md|RESOURCES\.md|NOTES\.md|learning-records|lessons/|reference/|temporary directory|OS temp|save it|save to|write (it|this|the|a|to)|create (it|this|the|a|files?)|output (to|into|under)|issue tracker'

{
  echo "# Location audit"
  echo "# commit: $(git rev-parse HEAD)"
  echo
  rg -n -i --glob '*.md' --glob '!skills/deprecated/**' \
    --glob '!skills/misc/adapt-matt-pocock-skills/**' \
    "$PATTERN" skills | LC_ALL=C sort
} > "$OUTPUT"

if [[ "$OUTPUT" != /dev/stdout ]]; then
  echo "wrote $OUTPUT"
fi
