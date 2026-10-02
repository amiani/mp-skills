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
| `to-tickets` | Local tickets | Follow tracker config; per-ticket files under the configured local-tracker route |
| `triage` | Rejected-request knowledge base | Use configured rejected-requests route |
| `to-questionnaire` | Questionnaire document | Use configured questionnaire route, then research route, then ask |
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
| `implement-spec` | Tracker; exploration notes | Resolve tracker through ancestor config; notes go to research route or OS temp |
| `wayfinder` | Tracker and domain docs | Resolve through ancestor config; tracker controls physical storage |
| `pr` | Domain glossary vocabulary | Use configured glossary |
| `wait-what` | Domain glossary vocabulary | Configured external domain route overrides repo root |
| `ask-matt` | Routing descriptions | Describe workspace-aware behavior accurately |
| `grill-with-docs` | Invokes domain modeling | No direct patch required while composition remains unchanged |
| `prototype` | Answer capture in issue or commit | No patch: prototype code is kept on a throwaway branch; the answer goes to the configured tracker |

## Safe or user-selected outputs

- `handoff`: OS temporary directory.
- `improve-codebase-architecture` HTML report: OS temporary directory.
- `writing-fragments`, `writing-shape`, `writing-beats`: user-selected path.
- `grilling`, `grill-me`, `writing-for-agents`: no local artifacts.
- `retro`: presents candidates only; any accepted change is a project modification.

## Intentional project modifications

- `implement`, `implement-spec`, `tdd`, `diagnosing-bugs`: product code and tests.
- `prototype`: runnable prototype code on a throwaway branch.
- `wizard`: ephemeral script plus `.env` / GitHub secrets the user asked for.
- `setup-pre-commit`, `scaffold-exercises`: requested repository output.

## Excluded from installation

- Deprecated and removed upstream skills (`resolving-merge-conflicts`, `writing-great-skills`).
- In-progress and personal skills unless explicitly added to the install manifest.
