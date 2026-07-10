---
name: adapt-matt-pocock-skills
description: Synchronize this fork with mattpocock/skills and preserve the external-artifact workspace workflow. Use when updating the fork, auditing new or changed skills for repository-relative artifact paths, or repairing adaptations after an upstream rebase.
disable-model-invocation: true
---

# Adapt Matt Pocock Skills

Maintain the `amiani/artifact-workspaces` branch as a small patch stack over
`upstream/main`. Preserve upstream behavior except where generated artifacts are
read from or written to the wrong workspace.

Read before changing anything:

- [ARTIFACT-ROUTING-CONTRACT.md](ARTIFACT-ROUTING-CONTRACT.md)
- [ADAPTATION-MATRIX.md](ADAPTATION-MATRIX.md)

## Update workflow

1. Verify this is the `mp-skills` checkout, the worktree is clean, and the
   current branch is `amiani/artifact-workspaces`.
2. Read `UPSTREAM-BASE`, then fetch `upstream`.
3. Inspect `git diff <old-base>..upstream/main -- skills docs`. Identify added,
   removed, renamed, and changed skills before rebasing.
4. Run `scripts/audit-locations.sh`. Classify every new location assumption as:
   external artifact writer, external artifact reader, OS-temporary output,
   user-selected output, intentional project modification, or example only.
5. Rebase onto `upstream/main`. Resolve conflicts by retaining upstream behavior
   and reapplying the smallest routing adaptation that satisfies the contract.
6. Audit the entire current skill tree, not only changed files. Update
   `ADAPTATION-MATRIX.md` for new skills or assumptions.
7. Run `scripts/verify-adaptations.sh`. Fix every failure and review every
   unclassified candidate.
   Use `scripts/check-routes.sh` against configured workspaces when routing
   files changed.
8. Replace `UPSTREAM-BASE` with `git rev-parse upstream/main`.
9. Fast-forward the local `main` reference to `upstream/main` and update
   `origin/main` without force; `main` is the pristine upstream mirror.
10. Show the user `git diff upstream/main...HEAD` and ask before committing,
   force-pushing the rebased branch, or synchronizing installed skills unless
   they already authorized the complete update.
11. Run `scripts/sync-installed-skills.sh` only after verification passes.

## Adaptation rules

- Configuration discovered through ancestor `AGENTS.md` or `CLAUDE.md` files
  overrides every repo-relative default.
- Treat path examples in upstream skills as defaults, not mandates, when an
  artifact route is configured.
- Route durable workflow artifacts outside the subject Git repository.
- Keep source, tests, fixtures, and deliberately temporary prototype code in the
  subject repository when that is the skill's purpose.
- Do not solve routing by ignoring generated files in Git. Physical separation
  is the invariant.
- Do not customize unrelated upstream wording or behavior.

## Completion criteria

- The branch rebases cleanly on the latest `upstream/main`.
- Every location-sensitive skill is represented in the adaptation matrix.
- Verification passes and configured artifact routes cannot resolve inside a
  subject Git root without explicit opt-in.
- The installation manifest contains no removed, renamed, personal, or unwanted
  upstream skills.
