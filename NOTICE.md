# Licence and rights

Copyright 2026 Bad Monkey, Inc. (https://badmonkey.ai)

## What this repository contains

This repository holds the **AgentSpaces specification and conformance kit**: `SPEC.md` and
`TECH-SPEC.md` are documents, and they are licensed as documents. `golden.json` and
`sync-golden.sh` are data and code, and they are licensed as code.

## Specification text

The prose of every specification (SPEC.md, TECH-SPEC.md) in this repository, including this file and the README, is
licensed under
**[Creative Commons Attribution-NoDerivatives 4.0 International (CC BY-ND 4.0)](LICENSE)**.

In plain terms: you may copy and redistribute the specifications, in any medium or format, for any
purpose including commercially, provided you give appropriate credit. You may not distribute
modified versions of the specification text.

Our plan is to move the spec to a standards body after the 1.0 release, and we'll update this accordingly.

## Code, vectors and samples

`golden.json`, `sync-golden.sh`, and the code, JSON, YAML and CBOR samples embedded in the
specifications are licensed under **[Apache License 2.0](LICENSE-SAMPLES-APACHE-2.0)**, so you
can copy them into your own implementation, vendor the golden vectors into your test suite, and
adapt them freely. The no-derivatives term applies to the specification prose, never to the
vectors or the examples.

## Implementing the specification

This specification exists so that implementations in any language can claim conformance to it.
`TECH-SPEC.md` §1.5 defines conformance and §10 is the checklist a new implementation follows.

Building an implementation, or building agents, applications, tools or services on one, places
no obligation on you under this document:

- Implement the wire protocol, in any language, publicly, privately, or as a commercial product.
- Vendor `golden.json` and run the conformance vectors in your own build.
- Build applications and agents over any conforming implementation.
- Do all of it without permission, notification or royalty.

**Implementations and applications you build are yours.** They are not derivative works of this
document, and nothing here places any licence condition on them or on anything they produce.
Attribution is required only if you redistribute the specification *text* itself.

## Trademarks and patents

The Creative Commons licence grants no trademark or patent rights (CC BY-ND 4.0 §2(b)(2)). Use
of the "AgentSpaces" and "Bad Monkey" names in a product name, brand or marketing is not granted
by this document.

## Contributions

The specification is authored and maintained by Bad Monkey, Inc. Issues and discussion are
welcome on the repository; Bad Monkey decides what the specification contains.

## Questions

If a use you have in mind is not clearly covered above, in particular anything involving
redistribution of modified text, ask at https://badmonkey.ai. It is cheaper for everyone to
confirm than to guess.
