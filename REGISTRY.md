# AgentSpaces registry of open values

**Written for:** implementers who write or read an `AppCard`'s `origin` and `formats`, and anyone who wants to add a value.

| | |
|---|---|
| Document | `agentspaces-spec/REGISTRY.md`, revision 4, 2026-11-11 |
| Status | The registry starts with SPEC v0.1.32. Revision 1 (2026-11-09) opens it. Revision 2 (2026-11-09) states that no origin system fixes a kind, and registers the system `console` for the apps a console drafts. Revision 3 (2026-11-10) points each protocol citation at `SPEC.md` and changes no value. Revision 4 (2026-11-11), with SPEC v0.1.33 and `REALM.md` revision 4, registers the `realm` keys `realm.commit` and `realm.digest` in place of the proposed `realm.bundle`. |
| Scope | `AppCard.origin.system`, the `origin.attrs` keys of each system, and the well-known entries of `AppCard.formats` (SPEC §6.1a.2) |

## 1. The lists are open

A reader never refuses a card because it names a system, an attribute, or a format this registry lacks, as long as the value meets the grammar of SPEC §6.1a.2. The registry exists so that two parties who mean the same thing write the same string, and so that discovery by origin or by format finds what it should. Registering a value changes no schema, no wire version, and no golden vector. The closed fields of the card (`kind`, `shape`, `ui.transport`, `ui.components[].role`, `host.signOn`, `host.status`) stay in `SPEC.md` and change only with a SPEC revision.

No origin system fixes a card's `kind` (SPEC §6.1a.2). A row names what the system is and how its `ref` and `attrs` read, and it never names a kind: the publisher chooses the kind from how the app connects (SPEC §6.1a.2), and a reader never refuses or reinterprets a card for its pair of kind and origin. Where a row says which kind a known importer writes, it describes that importer's behaviour today. Neither `origin` nor `formats` ever moves into a card's spill (SPEC §6.1a.5), so discovery by origin and by format reads a stub as it reads a full card.

The registry keeps its values apart from `SPEC.md` on purpose. A value joins here without a SPEC revision, as an IANA registry grows apart from the RFC that created it (RFC 8126).

## 2. Origin systems

`origin.system` holds 1 to 64 UTF-16 code units of `[a-z0-9]`, `.`, and `-`, starting and ending with a letter or digit. A registered system is a short token with no `.`. An unregistered system uses a reverse-DNS name its owner controls, with at least one `.` (`com.example.catalog`), so a private name never collides with a registered one.

| System | Status | What it names | `origin.ref` | `origin.attrs` keys |
|---|---|---|---|---|
| `realm` | registered | an app of an Embabel realm that a console imported (`REALM.md` §5); the reference console's importer writes kind `fed` today | `<realm>/<app>`, each part `[A-Za-z0-9._-]+` | `realm.format`, `realm.namespace` (both required), `realm.digest` (recommended), `realm.reads`, `realm.commit` |
| `console` | registered | an app a console drafted for a group from its agents' `ui` declarations (SPEC §6.1a.3), which the console's agents feed; the console that drafted it issues the card, and writes kind `fed` today | `<console>/<app>`, each part `[A-Za-z0-9._-]+`: the name the console publishes under, then the app's name in that console | none |
| `embabel` | candidate | an app in an Embabel-side app catalogue, outside any realm. An Embabel agent that joins as a member is kind `peer` and needs no origin. | not yet defined; the contact defines it with the Embabel team | none yet |
| `a2a-registry` | candidate | an agent application found in an A2A registry through its Agent Card | the Agent Card's URL | `a2a-registry.registry` (the registry's base URL) |
| `mcp-registry` | candidate | an MCP server's application listed in an MCP registry | the server's name in the registry | `mcp-registry.registry` (the registry's base URL) |

For `realm`, `origin.version` holds the realm's own semver, and `REALM.md` §5 gives the value of each key and the card's app link `app://<realm>/<app>`.

For `console`, `origin.version` holds `""`, since the card's own `version` already carries the drafted app's version. A console writes its own name into `ref` as data, so the row names no product.

A *candidate* is a value the maintainers expect and have not yet defined. A writer may use a candidate only with the `ref` grammar this table gives, and a writer does not use a candidate whose row gives no `ref` grammar (today `embabel`). The AgentSpaces maintainers promote a candidate to *registered* when its row is complete (§4).

Every `origin.attrs` key starts with the value of `origin.system` and a `.`, so two systems never share a key. A key is at most 128 code units long.

## 3. Formats

A `formats` entry without `:` is a media type, lower-case `type/subtype` under RFC 6838, with no parameters. An entry with `:` is the IRI (RFC 3987) of a vocabulary: a JSON-LD context, a profile, or an ontology namespace. A media type with a profile, such as JSON-LD with a profile, becomes two entries: `application/ld+json` and the profile's IRI.

IANA registers the media types below under the cited specifications. This registry adds no media type; it lists the ones AgentSpaces apps commonly name.

| Entry | Meaning |
|---|---|
| `text/html` | an HTML page a person opens (the WHATWG HTML Living Standard) |
| `application/json` | JSON documents (RFC 8259) |
| `application/ld+json` | JSON-LD 1.1 documents (W3C Recommendation) |
| `application/geo+json` | GeoJSON features and geometries (RFC 7946) |
| `text/csv` | comma-separated values (RFC 4180) |
| `text/markdown` | Markdown text (RFC 7763) |
| `text/calendar` | iCalendar data (RFC 5545) |
| `application/pdf` | PDF documents (RFC 8118) |
| `image/svg+xml` | SVG drawings (W3C SVG) |
| `application/cbor` | CBOR documents (RFC 8949) |

Vocabulary identifiers:

| Entry | Meaning |
|---|---|
| `https://schema.org/` | the schema.org vocabulary, also its JSON-LD context |
| `https://www.w3.org/ns/activitystreams` | the Activity Streams 2.0 JSON-LD context |
| `http://www.w3.org/ns/dcat#` | the DCAT data catalogue vocabulary |
| `http://www.w3.org/ns/prov#` | the PROV-O provenance ontology |
| a realm's `realm.namespace` | the types of one realm, `urn:realm:<name>#` by default (`REALM.md` §5) |

An app's A2UI catalogs belong in `ui.catalogIds` (SPEC §6.1a.2). A writer does not repeat them in `formats`.

## 4. How a value joins

1. The proposer opens a pull request against this file that adds one row. An origin system row gives the system token, what it names, the `ref` grammar, the `attrs` keys with their grammar, and a public definition of the source system. A format row gives the entry and its public specification.
2. The proposer names a *contact*, a person or project who answers questions about the value.
3. The AgentSpaces maintainers review the row on its merits (the Expert Review policy of RFC 8126 §4.5). They check that the value is distinct from every existing row, that it fits the grammar of §2 or §3, and, for a format, that IANA lists the media type or that the IRI resolves to a published vocabulary.
4. Once the maintainers merge the row, the value counts as registered. No implementation changes, because readers already accept it.

The maintainers never delete a row. They mark a row *deprecated* and name its replacement, so a reader keeps understanding old cards.
