# Versioning

Written for: anyone who changes the specification or a signed structure.

The specification's revision history is SPEC.md §15. A change to any signed structure
regenerates the vectors, and the Java, Python, TypeScript, and Ruby suites must be green before the
change lands. [How the implementations use the vectors](implementations.md) names each suite and its copy of
`golden.json`.
