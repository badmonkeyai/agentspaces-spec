# AgentSpaces and Realm

**Written for:** implementers of AgentSpaces readers and consoles who meet an `AppCard` with `origin.system` `realm`; the Embabel team, who own the realm side; architects who decide how a customer's realm becomes a running fleet.

| | |
|---|---|
| Document | `agentspaces-spec/REALM.md`, revision 4, 2026-11-11, a companion document to `SPEC.md` |
| Status | Informative, except §5, which is normative with SPEC v0.1.33 and which `REGISTRY.md` points to. SPEC v0.1.32 adds `origin` and `formats` to the card (§6.1a.2). Revision 1 (2026-11-09) states the relationship of AgentSpaces and Realm. Revision 2 (2026-11-09) moves the type names out of `reads` into `origin.attrs`, and records that the importer's kind `fed` is how the reference console works today, with no protocol rule behind it. Revision 3 (2026-11-10) answers the former question 1 from the Embabel Realm Specification (`embabel-worlds/realm-spec` at commit `89faba6`) in §1, states in §1, §2, and §4 the answers to the other former questions of §8 and removes §8, adds the Intent section, points each protocol citation at `SPEC.md`, corrects what §1, §2, §4, §6, and §7 said of the Embabel format, and names the console's folded document the *import document* outside §5. Revision 4 (2026-11-11), with SPEC v0.1.33, gives `origin.version` the realm's own semver, makes `realm.format` the form read and the commit of the Embabel Realm Specification the reader follows, replaces the proposed `realm.bundle` with `realm.commit` and `realm.digest`, gives each realm app card the app link `app://<realm>/<app>` of the Embabel Realm Specification, and says *import document* in §5 too. |
| Sources | The AgentSpaces + Realm site (its `realm/` pages: `index.html`, `mapping.html`, `example.html`); the Embabel Realm Specification (`embabel-worlds/realm-spec` at commit `89faba6`); the *AgentSpaces to Realm Specification*, version 2 of 2026-11-10, the reference console's own reading of the realm format, which the site follows; the reference console's import document reader and importer and its end-to-end test of the import; `SPEC.md` §1, §6.1a.2, §6.1c (the action contract), §10; `agentspaces/embabel-agentspaces/README.md`. This document calls the console that ships the realm importer the *reference console*. |

## Intent

This section is informative. AgentSpaces, Embabel, and Realm work better together. This section says how, and what this document is for.

AgentSpaces runs Embabel agents as a fleet for one use case, including Embabel agents that draw on realms. Each part brings its own share:

| Part | What it brings |
|---|---|
| Embabel | agents on the JVM, whose actions declare preconditions, effects, and costs, and planners that chain those actions toward a goal |
| A realm | the definitions of a domain: its agent definitions, the tools they use (APIs and their operations), the data they reference (the types, and the producers that fetch each object), and the pages over that data (the apps) |
| AgentSpaces | the fleet: peers that share typed entries in spaces, advertise what they do on signed cards, and find each other by discovery |

A realm holds many definitions, and one use case needs a set of them. AgentSpaces lets a team take that set from the realm and deploy it as one fleet. Today a console reads the realm and drafts the fleet's records from its definitions (§4):

- The types become the fleet's entry vocabulary.
- The tools a shipped connector serves, API operations and SQL queries, become `AssetCard`s.
- The other producers become the `AgentCard`s of a fleet package that serves them. A realm ships no code to the fleet.
- The APIs become `FlowManifest`s.
- The apps become `AppCard`s whose `origin` names the realm (§5).

A realm's own agent definitions stay with the world that installs the realm. The console drafts only each agent's prompt, when the import document carries the agent's prompt file. An operator approves the drafts the use case needs, and the console publishes them into one group. The `embabel-agentspaces` module brings an Embabel application's own agents into the same group, each `@Agent` as an `AgentCard` (§3). Embabel's planner then plans over every action the fleet advertises.

A platform built on AgentSpaces can then add guardrails, rules, and flows to that fleet, so its agents work with the realm's data under the operator's control. Those rules and flows use the realm's type names, which the import made the fleet's vocabulary (§2).

Each side keeps what it owns. Embabel authors and governs the realm format in the Embabel Realm Specification. The AgentSpaces specification defines the cards, the spaces, and the flows. A console owns the import and its review.

This document says how a realm's definitions reach an AgentSpaces fleet:

| Section | What it covers |
|---|---|
| §1 | what a realm holds, and who owns its format |
| §2 | what the realm, the protocol, and a console each own |
| §3 | how Embabel fits |
| §4 | which AgentSpaces record each realm part becomes |
| §5 | what an `AppCard` with a realm origin promises, the one normative section |
| §6 | how an import runs, from fold to retire |
| §7 | a worked example |

AgentSpaces software reads realms. This document claims no compatibility or conformance with the Embabel Realm Specification.

## 1. What Realm is

AgentSpaces builds in part on Embabel. A fleet gains when an Embabel application joins it, and gains again when the customer describes its domain as a realm. This document states that relationship, what each side owns, and what a reader may rely on.

The AgentSpaces + Realm site and the reference console describe an Embabel *realm* as a package of meaning. It holds five parts:

- **types**: the domain objects, each with a name, identity keys, typed fields, parent types, and references to other types (`virtualJoins`). The reference console turns each `spine` entry into a string property and a true `userAnchor` into a boolean property, and interprets neither further.
- **producers**: how the realm obtains each object. A producer has a kind: `remote` or `api` (an operation of one of the realm's APIs), `sql` (a datasource and a query), or `compute`, `vector`, `generative`, `aggregate`, `jar`, `source-tree` (in an AgentSpaces group a fleet package serves these, since a realm ships no code to the fleet).
- **APIs**: the remote operations the producers call, each with its OpenAPI 3.x document.
- **apps**: pages over the objects. A world serves a realm's app at `/apps/<realm>/<name>.html` (the Embabel Realm Specification, `apps/`).
- **prompts**: in the Embabel Realm Specification each agent has a prompt file, and a `prompts/` folder holds examples for a world's chat. The reference console drafts each agent's prompt file as a prompt. Its import document also has a `prompts` key in a shape of the console's own: the texts the agents run, with declared variables.

On disk a realm is a directory tree: `realm.yml`, `types/`, `producers/`, `apis/` (an `apis.yml` and an OpenAPI file per API), `apps/`, and `prompts/`. A console reads one document, the *import document*: the tree folded into a single YAML 1.2 document with the parts as top-level keys. Today a person folds the import document by hand. The Embabel Realm Specification now prefers a realm written in `realm.ts`, and the reference console reads the YAML form only. The import document's `realm:` key carries `name`, `version` (the realm's own semver, as in `realm.yml`), `commit` (the commit the realm's files came from), `namespace` (the IRI (RFC 3987) namespace of the types, default `urn:realm:<name>#`), `url` (the realm's source repository or documentation link, as in the Embabel Realm Specification), and `description`. Two of these keys are the import document's own: `commit`, and `namespace`, which the Embabel Realm Specification has no key for, since the realm's own label qualifies its type names.

**Who owns the format.** Embabel publishes the realm format in the Embabel Realm Specification, the `README.md` of the repository `embabel-worlds/realm-spec`, and Embabel alone authors and governs it (its `NOTICE.md`, Contributions); the *AgentSpaces to Realm Specification* this document cites is the reference console's own reading of it. The Embabel Realm Specification carries no format version number: the repository's git history versions it, and a host targets one revision of it, which is one commit of that repository (its `README.md`, Versioning).

**The content version.** A realm's content version is its `version`, the realm's own semver, as the Embabel Realm Specification defines it (its `README.md`, `realm.yml`). An `AppCard` of a realm app carries that semver in `origin.version`, and `origin.attrs["realm.format"]` names the form the console read and the commit of the Embabel Realm Specification its reader follows (§5). The reference console writes `realm.format` as `yaml@` followed by that commit.

## 2. The two worlds

A realm answers *what are the objects, and where do they come from*. It knows nothing of peers, leases, takes, or who is on duty. An AgentSpaces group answers *who works on the objects, and how*: its spaces (lanes of typed entries agents write and take), its cards (what each agent, asset, model, and app advertises), its flows, and its rules. It knows nothing of a producer's SQL or an API's token until a configuration tells one of its agents.

A console joins the two. It reads the realm, drafts what the group will need, shows an operator every draft of one import, and carries what the operator approves into the group. The realm's type names become the vocabulary of the fleet: the entries in the lanes, the sentences of the rule books, the cues of the flows, and the goals of the planner. Data moves one way, from the realm into the group, and no console writes back into a realm.

| Concern | The realm (the Embabel side) owns | The AgentSpaces protocol owns | A console owns |
|---|---|---|---|
| Types | names, identity keys, fields, parents, references | entry type IRIs as data; it interprets none of them | the drafts of the types and their review |
| Producers | kind, operation, datasource, query, and each producer's other fields | the `AssetCard` a connector publishes for what it serves (SPEC §6.1a) | the configuration drafts, credential references, approval |
| APIs | the OpenAPI documents and the operations they list | the `FlowManifest` a group's reconciler applies (SPEC §10.3) | the flow drafts and their activation |
| Apps | the pages, and where a world serves them (the import document adds the types each page reads) | the `AppCard`: `kind`, `shape`, `origin`, `formats`, `ui`, `host` (SPEC §6.1a.2 to §6.1a.4) | admission and publication into the group |
| Prompts | each agent's prompt file and the `prompts/` examples | nothing | the import document's `prompts` key, the prompt drafts, and their approval |
| Other producer kinds | the producer's declaration; a realm ships no code to the fleet | the `AgentCard`s a fleet package's agents publish (SPEC §6.1) | the package catalogue and the deployment |
| Identity | nothing: client credentials belong to the deployment (the Embabel Realm Specification, OAuth2) | `idpClient` and `host.signOn` `idp` or `none` | the deploying site's identity provider binding |
| The format | its structure and its versions | the registry entry `realm` (`REGISTRY.md`) and §5 | the import document reader and its report |

## 3. How Embabel fits

Embabel is an Apache 2.0 agent framework on Spring AI. It contributes `@Agent`, `@Action` (with `pre`, `post`, and `cost`), `@AchievesGoal`, `@Condition`, a typed blackboard, and GOAP, Utility, Hybrid, and Supervisor planners that replan after every action. An Embabel agent process and its blackboard live in one JVM.

AgentSpaces builds on that design language:

- SPEC §1 names the Embabel extension, `embabel-agentspaces`, as the first delivery target. An AgentSpace generalizes Embabel's per-process blackboard into a shared, leased, peer-to-peer blackboard that spans many agents on many machines.
- Principle P5 (typed entries, domain-first) follows Embabel's domain-model philosophy: entries are plain records matched by type and template.
- The action contract of SPEC §6.1c (`pre`, `post`, `cost`) carries Embabel's `@Action(pre, post, cost)` onto a card.
- SPEC §10 specifies the extension and its fluent space API, which mirrors Embabel's `ai.withLlm(...).createObject(...)` style.

AgentSpaces benefits when Embabel is in the picture. The `embabel-agentspaces` module publishes each `@Agent` as an `AgentCard` (`EmbabelBinder`, SPEC §10.4). It also generates a typed Embabel agent whose actions invoke the fleet's advertised capabilities (`EmbabelRemoteActions`), and redeploys it as cards arrive and lapse. Embabel's GOAP planner therefore plans over the whole fleet's actions. The module reads Embabel reflectively, so it builds with no Embabel artifact and activates only when Embabel is on the classpath. `EmbabelFleetPlanningTest` (`integration-tests/embabel-it`) and the Party Bus planner exercise it.

A realm benefits AgentSpaces further. The Embabel extension brings an Embabel application's agents into a fleet. A realm brings the domain those agents work on: the types become the fleet's entry vocabulary, the producers become served assets, the APIs become flows, the apps become cards a member finds by discovery, and the prompts become governed texts. The `origin` field of v0.1.32 keeps that provenance visible on every app card.

## 4. The mapping

A console drafts each realm part, an operator approves it, and the console publishes it. The table names the AgentSpaces record that reaches the group. The AgentSpaces to Realm Specification gives the reference console's own records and approval rules.

| Realm part | AgentSpaces record in the group |
|---|---|
| `realm` (`name`, `version`, `commit`, `namespace`) | `origin` on each app card (§5); the namespace of every entry type IRI |
| `types` | entries whose schema name is the type's IRI, the namespace followed by the type name |
| producers of kind `remote` or `api` | an `AssetCard` per operation, from a shipped OpenAPI 3.x and REST connector, configured with the API's location, a credential reference, the operation, the base URL from the document's first server, and the auth scheme |
| producers of kind `sql` | an `AssetCard` per query, from a shipped SQL connector, configured with the datasource and the query |
| producers of any other kind | the `AgentCard`s of a fleet package that serves the agent kind `<realm>/<producer>`, configured with the producer's fields |
| `apis` | a `FlowManifest` with one code stage per listed operation, on a lane named after the API; the operation's request schema cues each stage, its parameters are cue fields, and its response schema is the result |
| `prompts` | the group's prompt set, carried as a configuration |
| `apps` | an `AppCard` with owner the realm, `origin` `realm`, `formats` with the realm's namespace, and the app link `app://<realm>/<app>` (§5); the reference console writes kind `fed` |

A realm names no spaces of its own. The lanes come from the flows its APIs become and from the console's own lanes. A realm imports into one group per import and creates no group.

The reference console ships two connectors for realm producers: an OpenAPI 3.x and REST connector, which serves the kinds `remote` and `api`, and a PostgreSQL connector, which serves the kind `sql`. A producer of any other kind becomes a configuration for the agent kind `<realm>/<producer>`, which a fleet package serves. Which kinds a console serves with shipped connectors is the console's own choice. The Embabel Realm Specification defines the fields of every producer kind (its `VIRTUAL_CYPHER.md` §5.3).

Before v0.1.32 the reference console wrote apps as kind `realm` and copied the type names into `reads`. v0.1.32 moves the provenance to `origin`, and revision 2 of this document moves the type names to `origin.attrs["realm.reads"]` (§5), because SPEC §6.1a.2 defines `reads` as `group/space` pairs. The reference console's importer writes kind `fed`, since a realm app is a page that an agent of the group feeds when anything does. That choice is the importer's behaviour today: the protocol ties no kind to an origin, and a later importer may choose another kind, such as `assembled` for a realm page published with its data extracted (SPEC §6.1a.2).

## 5. What `origin` realm promises (normative)

The key words MUST, SHOULD, and MAY follow BCP 14 (RFC 2119, RFC 8174).

A console reads the realm's *import document*, the realm's directory tree folded into one YAML 1.2 document (§1). A console MUST NOT refuse an import document for its `realm.version`, which is the realm's own content version (§1). A realm name and an app name match `[A-Za-z0-9._-]+`. A console that meets another name reports it and drafts no card for that app.

An `AppCard` whose `origin.system` is `realm` MUST carry:

- `origin.ref`: `<realm>/<app>`, where `<realm>` is the import document's `realm.name` and `<app>` the `name` of one entry of its `apps`.
- `origin.version`: the import document's `realm.version` when it is a semantic version (SemVer 2.0.0) of at most 64 UTF-16 code units, the bound SPEC §6.1a.2 sets on `origin.version`, and `0.0.0` when the import document names none, as for a `realm.yml` that names none (§1). A version of another form, or a longer one, leaves `origin.version` `""`, and the console reports it.
- `origin.attrs["realm.format"]`: `<form>@<commit>`. `<form>` is a lower-case token for the form the console read, `yaml` for the YAML import document. `<commit>` is the commit of the Embabel Realm Specification the console's reader follows, as 40 lower-case hexadecimal digits, since a commit of that repository is how a reader names one revision of it (§1).
- `origin.attrs["realm.namespace"]`: the import document's `realm.namespace`, or `urn:realm:<realm>#` when it names none.
- `owner`: `<realm>`.
- `url`: the app link `app://<realm>/<app>`, the app's own address in the Embabel Realm Specification (its `README.md`, `apps/`, Linking into an app). A world that installs the realm serves the app's page at `/apps/<realm>/<app>.html`, so the link opens the app wherever a world serves the realm's apps and names no host of its own. The import document's `realm.url` is the realm's source repository or documentation link, and no card link derives from it.
- `formats`: `text/html` first when the app's file ends in `.html` or `.htm`, then the value of `realm.namespace`.

This section constrains no `kind`. A reader never infers a kind from a realm origin, and never refuses a realm card for its kind.

It SHOULD carry:

- `origin.attrs["realm.digest"]`: `sha256:` followed by the 64 lower-case hexadecimal digits of the SHA-256 (FIPS 180-4) of the import document's UTF-8 bytes, as the console received them.

It MAY carry:

- `origin.attrs["realm.reads"]`: the type names the app entry lists under `reads`, comma-separated without spaces, in the import document's order. A writer omits it when the entry lists none, and when the value would pass 256 code units, which the console reports.
- `origin.attrs["realm.commit"]`: the import document's `realm.commit`, the commit of the realm's own repository its files came from, as 40 lower-case hexadecimal digits. A writer omits it when the import document names none or names one of another form, which the console reports.

A writer never writes `origin.attrs["realm.bundle"]`. Earlier revisions of this document proposed that key, and revision 4 replaces it with `realm.commit` and `realm.digest`.

By publishing such a card, the issuer asserts four things under its signature. The app is an entry of the import document it read. The version, namespace, commit, and type names are the import document's own, and the digest is that document's SHA-256. The link is the app's address in the realm, `app://<realm>/<app>`. Its console admitted the card before it published it. The card makes no claim that the realm's authors approved the publication, and AgentSpaces carries no signature from them today.

The same realm imported into two groups yields two cards with the same `origin.ref`. That is the intended reading: `group` and `id` tell the cards apart.

While any member of the group is below `wire.appcard=2`, the issuer strips `origin` and `formats` (SPEC §6.1a.2, the AppCard level). A stripped realm card then reads as an app of its kind with empty `reads`, and only its `owner` still carries the realm's name, as plain text with no claim of provenance. A realm card that passes the spill threshold keeps `origin` and `formats` on its stub, because neither ever spills (SPEC §6.1a.5).

A reader that relies on a realm origin SHOULD verify it in four steps:

1. Verify the card as any card: the issuer's signature, an unexpired `ttl` (SPEC §6.2), and an issuer that belongs to the group.
2. Check that the group trusts the issuer to publish imports.
3. Check the claim's internal consistency: `owner` equals the first part of `ref`, `url` equals `app://` followed by `ref`, and `formats` holds the value of `realm.namespace`.
4. Where the reader needs the realm's own word, obtain the import document from the realm's owner out of band, check that its SHA-256 matches `realm.digest`, and compare `name`, the app entry, `version`, `commit`, and `namespace` with `ref`, `origin.version`, `realm.commit`, and `realm.namespace`.

A reader that finds a mismatch treats the card as an app of its kind with an unverified origin. The protocol never refuses a card for its origin (SPEC §6.1a.2).

## 6. The lifecycle of an import

1. **Fold.** A person folds the realm's directories into one import document, by hand today, with each OpenAPI document inline under its API.
2. **Import.** An operator or a script posts the import document to a console with the target group and an idempotency key.
3. **Read and draft.** The console reads the import document and drafts one record per type, producer, API, prompt, and app. Configuration drafts and prompts carry the origin `realm:<name>`. Flow drafts and app rows take the names `realm-<realm>-<api>` and `realm-<realm>-<app>`. The console's answer carries a report: what it could not read, which producer has no API, which package the catalogue still lacks, which app's file is not named after the app. The console never guesses a missing piece.
4. **Review and approve.** An operator reviews what one import proposed before approving any of it. The reference console's Configurations and Prompts screens filter by origin; the AgentSpaces to Realm Specification describes more filtering than the code offers today.
5. **Publish.** The console carries each approved row into the group, and publishes each app card as a signed advertisement under the AppCard level gate of SPEC §6.1a.2.
6. **Serve.** The shipped connectors publish `AssetCard`s for the operations and queries they serve, a fleet package reads the configurations addressed to its agent kinds, the reconciler applies the activated flows, and members find the apps by discovery, by origin, and by format.
7. **Import again.** A second import of the same realm drafts new versions of the same records, and nothing published changes without approval. A script may therefore import a realm on every build.
8. **Retire.** An operator retires an app. Its issuer stops reissuing the card, and the card lapses at its `ttl` (SPEC §6.2).

## 7. The worked example

The `claims-ops` realm of the example company Acme Insurance (`acme.example`) holds three types, four producers, one API with three operations, and two apps. Its import yields two REST connector configurations, one SQL connector configuration, and one configuration for the agent kind `claims-ops/riskScore`, which a fleet package serves. It yields one flow, `realm-claims-ops-claims-api`, with two stages (`listClaims` and `getPayment`; the API's `operation-ids` omits `orderPayment`). It yields two app cards, `claims-desk` and `ledger-view`. The `golden.json` entry `app_card_origin_formats_cbor` encodes a realm app card of the same shape under v0.1.33, with neutral names. The site's `example.html` walks the import end to end.

