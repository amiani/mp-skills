#!/usr/bin/env bash
set -euo pipefail

if (( $# < 2 )); then
  echo "usage: $0 <subject-git-repo> <artifact-path> [...]" >&2
  exit 2
fi

SUBJECT="$1"
shift
ROOT="$(git -C "$SUBJECT" rev-parse --show-toplevel)"
ROOT="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$ROOT")"
FAILED=0

for path in "$@"; do
  resolved="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$path")"
  case "$resolved" in
    "$ROOT"|"$ROOT"/*)
      echo "FAIL: artifact route is inside subject repo: $resolved" >&2
      FAILED=1
      ;;
    *) echo "ok: $resolved" ;;
  esac
done

exit "$FAILED"
