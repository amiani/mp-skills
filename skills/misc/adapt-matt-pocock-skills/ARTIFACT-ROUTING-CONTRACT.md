# Artifact Routing Contract

## Terms

**Subject repository** — the team Git repository whose code is being read or
changed.

**Agent workspace** — a personal directory outside the subject repository that
holds durable artifacts produced by agent workflows. It may be an ancestor of
one or more subject repositories.

**Artifact route** — an explicit absolute path for one class of artifact. A
workspace is a map of routes, not necessarily one undifferentiated root.

## Resolution order

Before reading or writing a workflow artifact, resolve its route in this order:

1. An explicit path supplied by the user for this invocation.
2. The nearest applicable ancestor `AGENTS.md` or `CLAUDE.md`, including any
   absolute configuration files it points to.
3. An established location recorded by the artifact set itself, such as the
   teaching workspace in `NOTES.md`.
4. Existing artifacts in an ancestor workspace.
5. Ask the user.
6. Use the upstream repo-relative default only when no subject Git repository
   would be polluted or the user explicitly opts into repo-local artifacts.

Once resolved, interpret all relative paths in the skill against that route.
Do not repeatedly ask after a route has been established.

## Route classes

| Route | Typical artifacts |
|---|---|
| Domain | `CONTEXT.md`, `CONTEXT-MAP.md`, `docs/adr/` |
| Agent configuration | `docs/agents/`, issue tracker and label instructions |
| Local tracker | PRDs, tickets, wayfinder maps, issue comments under `.scratch/` |
| Research | Cited research summaries |
| Rejected requests | `.out-of-scope/*.md` |
| Teaching | `MISSION.md`, `RESOURCES.md`, `NOTES.md`, lessons, assets, references, learning records |
| Workflow design | `workflows/*.md`, workflow-design `NOTES.md` |
| Temporary | Handoffs and generated review reports in the OS temporary directory |

Teaching and workflow-design routes can be per-topic rather than workspace-wide.

## Safety invariant

For every durable generated artifact:

1. Resolve the subject root with `git -C <subject> rev-parse --show-toplevel`.
2. Resolve the proposed destination to an absolute normalized path.
3. If the destination is the subject root or a descendant, stop and ask unless
   the user explicitly chose repo-local storage.

Git ignore rules are not a substitute for this invariant.

## Project modifications are not artifacts

Do not redirect files whose purpose is to change the product:

- source code and tests;
- fixtures needed by tests;
- repository configuration explicitly requested by the user;
- exercise/course content when the repository owns that content;
- temporary prototype code that must run against the real application.

Prototype code must be deleted or absorbed after the question is answered. Its
durable decision record follows the artifact routes.

## Recommended workspace configuration

An ancestor `AGENTS.md` should point to an absolute configuration document such
as `docs/agents/artifact-routing.md`. That document should name:

```markdown
# Artifact routing

Subject repositories:
- `/absolute/path/to/workspace/repo`

Routes:
- Agent configuration: `/absolute/path/to/workspace/docs/agents/`
- Domain glossary: `/absolute/path/to/workspace/CONTEXT.md`
- ADRs: `/absolute/path/to/workspace/docs/adr/`
- Local tracker: `/absolute/path/to/workspace/.scratch/`
- Research: `/absolute/path/to/workspace/.scratch/research/`
- Rejected requests: `/absolute/path/to/workspace/.out-of-scope/`
- Teaching: choose per topic and record in that workspace's `NOTES.md`
```

Use absolute paths so behavior is independent of the process working directory.
