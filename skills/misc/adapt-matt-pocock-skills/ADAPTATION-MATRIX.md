# Adaptation Matrix

This is the reviewed classification of location-sensitive current skills. Audit
the whole tree after every upstream update and extend this matrix before marking
the update complete.

## External artifact writers

| Skill | Artifact | Adaptation |
|---|---|---|
| `teach` | Teaching workspace files | Resolve or ask for a teaching route; record it in `NOTES.md` |
| `domain-modeling` | Glossary and ADRs | Resolve configured domain routes before repo defaults |
| `setup-matt-pocock-skills` | Agent config, domain docs, local tracker | Support an ancestor agent workspace and render absolute paths |
| `research` | Research summary | Use configured research route or ask |
| `to-tickets` | Local tickets | Follow tracker config; never hard-code repo-root `tickets.md` |
| `triage` | Rejected-request knowledge base | Use configured rejected-requests route |
| `prototype` | Durable decision note | Use issue, ADR, or configured research route; code remains temporary in repo |
| `loop-me` | Workflow specs and notes | Resolve or ask for a workflow-design workspace |

## Readers and indirect writers

| Skill | Dependency | Adaptation |
|---|---|---|
| `code-review` | Tracker config and spec | Resolve through ancestor config; search configured tracker before repo fallbacks |
| `tdd` | Domain glossary and ADRs | Resolve configured domain routes |
| `diagnosing-bugs` | Domain glossary and ADRs | Resolve configured domain routes |
| `improve-codebase-architecture` | Domain docs; invokes domain modeling | Resolve configured routes; report remains in OS temp |
| `codebase-design` | Domain vocabulary in design briefs | Use configured glossary when supplied |
| `to-spec` | Tracker and domain docs | Resolve through ancestor config |
| `wayfinder` | Tracker and domain docs | Resolve through ancestor config; tracker controls physical storage |
| `ask-matt` | Routing descriptions | Describe workspace-aware behavior accurately |
| `grill-with-docs` | Invokes domain modeling | No direct patch required while composition remains unchanged |

## Safe or user-selected outputs

- `handoff`: OS temporary directory.
- `improve-codebase-architecture` HTML report: OS temporary directory.
- `writing-fragments`, `writing-shape`, `writing-beats`: user-selected path.
- `grilling`, `grill-me`: no local artifacts.

## Intentional project modifications

- `implement`, `tdd`, `diagnosing-bugs`: product code and tests.
- `prototype`: temporary runnable code, later deleted or absorbed.
- `setup-pre-commit`, `wizard`, `scaffold-exercises`: requested repository output.

## Excluded from installation

- `obsidian-vault`: Matt-specific absolute vault path.
- Deprecated skills.
- In-progress and personal skills unless explicitly added to the install manifest.
