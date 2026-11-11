# AgentSpaces specification documents

Written for: anyone who read the README and wants the rest of the story.

The README is short by design: what this repository is, the quick start, and how to use the vectors. Everything else
lives here, one topic per document. The specification itself is in [SPEC.md](../SPEC.md), with
[TECH-SPEC.md](../TECH-SPEC.md), [REALM.md](../REALM.md) and [REGISTRY.md](../REGISTRY.md) beside it.

| Document | Written for | What it holds |
|---|---|---|
| [About](about.md) | anyone who builds, reviews, or checks an implementation | What each file of the repository is, and the licence in brief. |
| [How the implementations use the vectors](implementations.md) | maintainers of an implementation, and anyone who adds one | Where each implementation keeps its copy of `golden.json`, which suite reads it, and how the copies stay in step. |
| [The golden vectors](vectors.md) | anyone who writes or checks a conformance suite | The core entries to reproduce exactly and the hostile `adv_*` entries to refuse. |
| [Versioning](versioning.md) | anyone who changes the specification or a signed structure | Where the revision history lives, and what a change to a signed structure must pass. |
