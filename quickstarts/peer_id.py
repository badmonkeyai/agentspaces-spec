# Copyright 2026 Bad Monkey, Inc. Licensed under the Apache License, Version 2.0.
# Reproduces the first golden vector: PeerID = multibase(sha-256(public key)), SPEC §4.1.
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
