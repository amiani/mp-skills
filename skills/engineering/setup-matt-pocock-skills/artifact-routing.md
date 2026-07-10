# Artifact Routing

Generated workflow artifacts for this project use the routes below. Replace all
placeholders with absolute normalized paths during setup.

## Subject repositories

- `<absolute-subject-repository>`

## Routes

- **Agent configuration:** `<configuration-root>/docs/agents/`
- **Domain glossary:** `<configuration-root>/GLOSSARY.md`
- **Context map:** `<configuration-root>/GLOSSARY-MAP.md` (multi-context only)
- **ADRs:** `<configuration-root>/docs/adr/`
- **Local tracker:** `<configuration-root>/.scratch/`
- **Research:** `<configuration-root>/.scratch/research/`
- **Rejected requests:** `<configuration-root>/.out-of-scope/`
- **Teaching:** choose per topic and record the absolute route in that teaching workspace's `NOTES.md`
- **Workflow design:** choose per topic and record the absolute route in that workspace's `NOTES.md`

## Invariant

Do not write generated workflow or documentation artifacts inside a subject Git
repository unless the user explicitly opts into repo-local storage. Source,
tests, fixtures, and deliberately temporary prototype code remain project files.
