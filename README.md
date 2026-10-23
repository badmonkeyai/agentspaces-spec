# AgentSpaces specification and conformance kit

The language-neutral half of AgentSpaces: what every implementation claims conformance *to*.

**Licence.** The specification text in this repository (`SPEC.md`, `TECH-SPEC.md` and this
README) is [CC BY-ND 4.0](LICENSE); `golden.json`, `sync-golden.sh` and the embedded samples are
[Apache 2.0](LICENSE-SAMPLES-APACHE-2.0). Implementing the specification, and building on any
implementation, is free and unconditional. [NOTICE.md](NOTICE.md) states the rights in full, and
[License](#license) summarizes them.

| File | What it is |
| --- | --- |
| `SPEC.md` | The normative specification (v0.1.13): identity, peering, discovery, the replicated space, capabilities, the programming model, security. |
| `TECH-SPEC.md` | What the reference implementation puts on the wire, byte by byte, and which algorithm runs behind each operation; §1.5 defines conformance and §10 is the checklist a new implementation follows. |
| `golden.json` | The golden vectors: 197 named entries, 158 byte strings and values a conforming implementation reproduces exactly and 39 hostile `adv_*` inputs it refuses. |
| `sync-golden.sh` | Copies `golden.json` into every consumer's vendored location and checks the copies are identical. |

## How the implementations reference this

Each implementation keeps a **vendored copy** of `golden.json` at a fixed path, so every
repository builds and runs its conformance gate standalone and offline:

| Implementation | Vendored copy | Suite |
| --- | --- | --- |
| `agentspaces/` (Java, the reference) | `tools/golden/golden.json` | `GoldenVectorsConformanceTest`, `GoldenVectorsV0110ConformanceTest`, `AdversarialVectorsTest`, `SignedAgentVectorsClusterTest`, `VoteVectorsConformanceTest`, `IdsTest` — run with `-Dgolden.required=true` |
| `agentspaces-python/` | `tests/golden.json` | `tests/test_golden.py`, `tests/test_adversarial.py` |
| `agentspaces-typescript/` | `test/golden.json` | `test/golden.test.ts` |

This file is the source; the copies are derived. `sync-golden.sh` refreshes them and
`verify-all.sh` at the workspace root refuses when any copy differs. A vector is never edited
by hand: the generator (`agentspaces/tools/golden/GoldenVectors.java`, which needs the Java
classes and so lives with them) reloads the fixed key material from the existing file, adds or
changes only the vectors whose inputs changed, and writes here; see
`agentspaces/docs/BUILD-ENVIRONMENTS.md` for the incantation.

## The vectors

Fixed key material and identifiers: `private_key_pkcs8`, `public_key_raw`, `peer_id`,
`group_id`, `space_id`, `hlc_encoded`, and the adversarial forger's and the subordinate agent's
keys (`adv_forger_*`, `agent_*_key_*`). Everything else is a canonical CBOR encoding
(`*_cbor`), a signature (`*_signature`), a delta (`*_delta`), or a derived identifier, named
for the structure it pins.

### Reproduce exactly

- `private_key_pkcs8`
- `public_key_raw`
- `peer_id`
- `group_id`
- `hlc_encoded`
- `ping_body_cbor`
- `ping_envelope_cbor`
- `ping_frame_cbor`
- `ping_envelope_signature`
- `peer_ad_cbor`
- `signed_peer_ad_cbor`
- `intro_rumor_body_cbor`
- `task_payload_cbor`
- `space_id`
- `sign_view_cbor`
- `record_signature`
- `state_sign_view_cbor`
- `state_signature`
- `entry_state_dto_cbor`
- `delta_cbor`
- `take_claim_cbor`
- `take_claim_signature`
- `claim_delta_cbor`
- `digest_body_cbor`
- `max_frame_bytes`
- `founding_fields_cbor`
- `founding_signature`
- `founding_document_cbor`
- `founding_group_id`
- `founding_ad_id`
- `group_ad_cbor`
- `signed_group_ad_cbor`
- `group_ad_want_envelope_cbor`
- `group_ad_want_frame_cbor`
- `group_ad_envelope_cbor`
- `group_ad_frame_cbor`
- `agent_card_cbor`
- `agent_card_signature`
- `signed_agent_card_cbor`
- `space_ad_cbor`
- `space_ad_space_id`
- `space_credential_record_cbor`
- `aggregate_share_frame_cbor`
- `aggregate_extremum_frame_cbor`
- `aggregate_histogram_frame_cbor`
- `aggregate_roster_frame_cbor`
- `aggregate_roster_token`
- `learn_model_encoding`
- `learn_content_id`
- `learn_exchange_offer_cbor`
- `learn_exchange_accept_cbor`
- `learn_exchange_busy_cbor`
- `certificate_verify_at`
- `agent_private_key_pkcs8`
- `agent_public_key_raw`
- `agent_certificate_unsigned_cbor`
- `agent_certificate_signature`
- `agent_certificate_cbor`
- `record_signature_agent_key`
- `entry_state_with_certificate_cbor`
- `delta_with_certificate_cbor`
- `agent_card_with_key_cbor`
- `agent_card_with_key_signature`
- `take_claim_agent_signature`
- `claim_delta_with_certificate_cbor`
- `vote_three_names_one_peer_proposal`
- `vote_three_names_one_peer_delta_1`
- `vote_three_names_one_peer_delta_2`
- `vote_three_names_one_peer_delta_3`
- `wire_version`

Added in v0.1.13 (`TODO-9-10-11` Phase 3; every vector above keeps its bytes). The two
v0.1.11 vectors `entry_state_with_certificate_cbor` and `delta_with_certificate_cbor` now
carry a refused verdict: they put a peer-signed state on an agent-attested entry. They are
kept under their old names for continuity, and are also published as
`adv_legacy_state_on_attested_entry_*` below, the names the Java, Python, and TypeScript
suites check the refusal under.

- `state_sign_view_agent_cbor`, `state_signature_agent_key`: an agent-signed state's view
  (appends `signer`, `signedAt`) and the agent key's signature over it
- `entry_state_agent_signed_cbor`, `delta_agent_signed_cbor`: the agent-signed control,
  which every receiver accepts
- `content_key_epoch_2`, `content_key_aad_epoch_2`, `key_epoch_sealed_payload`,
  `sign_view_key_epoch_cbor`, `entry_record_key_epoch_cbor`: a record sealed under epoch 2
  (appends `keyEpoch`; the AAD appends `|2`)
- `epoch_commitment_cbor`, `epoch_proof_signature`: a rotator's signed commitment to an
  epoch key
- `wrap_binding_v2_cbor`: the key-wrap binding with `epoch`, `rotator`, and `agent`
- `agent_encryption_private_key_pkcs8`, `agent_encryption_public_key_raw`,
  `agent_certificate_with_encryption_unsigned_cbor`,
  `agent_certificate_with_encryption_signature`, `agent_certificate_with_encryption_cbor`:
  a certificate that also certifies the agent's X25519 key
- `credential_revocation_agent_cbor`, `signed_credential_revocation_agent_cbor`,
  `credential_revocation_agent_key_cbor`, `signed_credential_revocation_agent_key_cbor`:
  revocations of an agent (retired, effective an hour before issue) and of its key
  (key-compromise), issued by the agent's own peer
- `agent_card_with_actions_cbor`, `agent_card_with_actions_signature`: a card with a
  declared action and its agent's certificate, issued at `certificate_verify_at`

### Refuse identically

Every `adv_*` vector is a hostile input that decodes cleanly (or fails a bounds check) and
must be rejected — by failed verification, a lattice bound, or a reader filter — without
crashing the receiver. All three implementations reject the same set:

- `adv_claim_bad_signature_delta`
- `adv_claim_transplanted_delta`
- `adv_claim_nan_bid_delta`
- `adv_claim_epoch_zero_delta`
- `adv_claim_epoch_jump_delta`
- `adv_claim_eternal_delta`
- `adv_deep_nesting_cbor`
- `adv_frame_bad_signature`
- `adv_frame_wrong_destination`
- `adv_frame_wrong_destination_to`
- `adv_group_ad_wrong_id_cbor`
- `adv_group_ad_forged_signature_cbor`
- `adv_forger_private_key_pkcs8`
- `adv_forger_public_key_raw`
- `adv_cert_wrong_peer_delta`
- `adv_cert_wrong_agent_delta`
- `adv_cert_expired_delta`
- `adv_cert_uncertified_key_delta`
- `adv_cert_peer_signed_record_delta`
- `adv_claim_cert_peer_signed_delta`
- `adv_claim_cert_expired_delta`
- `adv_claim_cert_wrong_holder_delta`
- `adv_legacy_state_on_attested_entry_dto_cbor`, `adv_legacy_state_on_attested_entry_delta_cbor`
  (v0.1.13): a peer-signed state on an agent-attested entry
- `adv_agent_state_peer_key_delta` (v0.1.13): agent-signer fields, signed by the peer key
- `adv_agent_state_wrong_signer_delta` (v0.1.13): a signer other than the record's issuer

## Versioning

The specification's revision history is SPEC.md §15. A change to any signed structure
regenerates the vectors, and the three suites must be green before the change lands.

## License

The specification **text** is licensed under
[Creative Commons Attribution-NoDerivatives 4.0 International](LICENSE) (CC BY-ND 4.0). The
golden vectors, the sync script, and the code and data **samples** embedded in the documents are
under the [Apache License 2.0](LICENSE-SAMPLES-APACHE-2.0), so you can copy, vendor and adapt
them freely.

**Implementing this specification, and building agents and applications over any conforming
implementation, is free**, publicly, privately or commercially, without permission, notification
or royalty. Implementations you build are yours and are not derivative works of this document.
Attribution is required only when you redistribute the specification text itself.

See [NOTICE.md](NOTICE.md) for the full statement of rights.
