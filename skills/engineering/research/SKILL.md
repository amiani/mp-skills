---
name: research
description: Investigate a question against high-trust primary sources and capture the findings as Markdown in the configured research route. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent.
---

Spin up a **background agent** to do the research, so you keep working while it reads.

## Artifact routing

Resolve the research output route from the applicable ancestor `AGENTS.md` or
`CLAUDE.md` and its linked artifact-routing configuration. If none is configured,
ask where to save the summary. Do not default to writing inside a subject Git
repository merely because that is the current working directory.

Its job:

1. Investigate the question against **primary sources** (official docs, source code, specs, first-party APIs), not a secondary write-up of them. Follow every claim back to the source that owns it.
2. Write the findings to a single Markdown file, citing each claim's source.
3. Save it in the configured research route, matching any convention already present there, and report the absolute path. Repo-local notes are used only when explicitly configured.
