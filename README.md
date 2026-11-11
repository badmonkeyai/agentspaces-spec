# AgentSpaces specification and conformance kit

The language-neutral half of AgentSpaces, from Bad Monkey AI: the specification every implementation claims conformance *to*, and the golden vectors that prove it. It is written for anyone who builds, reviews, or checks an AgentSpaces implementation, in any language.

## Quick start: reproduce your first golden vector

A peer's ID is `multibase(sha-256(public key))` (SPEC §4.1). The program `quickstarts/peer_id.py` needs Python 3 and nothing else. It derives the ID from the vectors' public key and compares it with the `peer_id` entry:

```python
import hashlib, json, sys

vectors = json.load(open(sys.argv[1] if len(sys.argv) > 1 else "golden.json"))
digest = hashlib.sha256(bytes.fromhex(vectors["public_key_raw"])).digest()
alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
number, text = int.from_bytes(digest, "big"), ""
while number:
    number, digit = divmod(number, 58)
    text = alphabet[digit] + text
peer_id = "z" + "1" * (len(digest) - len(digest.lstrip(b"\0"))) + text  # "z" marks base58btc
print(peer_id, "matches" if peer_id == vectors["peer_id"] else "differs from " + vectors["peer_id"])
sys.exit(0 if peer_id == vectors["peer_id"] else 1)
```

Run it from this repository's root:

```
python3 quickstarts/peer_id.py golden.json
# z6M1N9PyyHGkJfLZRmQ4VjAypZUi5uuUm8UDMHK1YfieJ matches
```

`quickstarts/verify.sh` runs it the same way. A conformance suite does this for every entry: [the golden vectors](docs/vectors.md) lists them, and `TECH-SPEC.md` §10 is the checklist a new implementation follows.

## What it is

- `SPEC.md`: the normative specification, v0.1.33 (draft); §9.3 records what each implementation still lacks.
- `TECH-SPEC.md`: what the reference implementation puts on the wire, byte by byte, and the algorithm behind each operation.
- `REALM.md` and `REGISTRY.md`: how a realm's apps reach a fleet, and the registry of open values.
- `golden.json`: 293 golden vectors to reproduce exactly, hostile `adv_*` inputs included, which a conforming reader refuses.
- [About](docs/about.md) describes every file of the repository.

## Add it to your build

Nothing to compile: copy `golden.json` into your implementation's test resources at a fixed path, so your conformance suite runs standalone and offline, and copy it again when the specification moves. [How the implementations use the vectors](docs/implementations.md) shows where the Java, Python, TypeScript, Ruby, and Rust suites keep their copies, and how `sync-golden.sh` keeps the maintainers' copies in step.

## Where to read next

1. **[The developer guide](https://www.badmonkey.ai/agentspaces/developer-guide.html#test-conformance)**: its conformance section shows how the reference implementation runs the vectors.
2. **[The language guides](https://www.badmonkey.ai/agentspaces/developer-guide.html#other-languages)**: Python, TypeScript, Clojure, Groovy, Ruby, and Rust, each from a first agent to the capabilities.
3. **[The examples](https://github.com/badmonkeyai/AgentSpaces/tree/main/examples)**: the core's numbered examples, one primitive each, several with workers in other languages.
4. **[The documents](docs/README.md)**: everything this README leaves out, one topic per document, each with the reader it is written for.

## License

The specification **text** (`SPEC.md`, `TECH-SPEC.md`, `REALM.md`, `REGISTRY.md`, this README and the documents in
`docs/`) is licensed under
[Creative Commons Attribution-NoDerivatives 4.0 International](LICENSE) (CC BY-ND 4.0). The
golden vectors (`golden.json`, `golden-examples.json`, `negentropy-vectors.json`), the sync script, the quick start's
programs, and the code and data **samples** embedded in the documents are
under the [Apache License 2.0](LICENSE-SAMPLES-APACHE-2.0), so you can copy, vendor and adapt
them freely.

**Implementing this specification, and building agents and applications over any conforming
implementation, is free**, publicly, privately or commercially, without permission, notification
or royalty. Implementations you build are yours and are not derivative works of this document.
Attribution is required only when you redistribute the specification text itself.

See [NOTICE.md](NOTICE.md) for the full statement of rights.
