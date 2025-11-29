#!/usr/bin/env python3

import hashlib
from core.baseline import sha256_file


def load_baseline(baseline_path: str) -> dict:
    table = {}
    with open(baseline_path) as f:
        for line in f:
            h, path = line.strip().split(" ", 1)
            table[path] = h
    return table


def verify_file(path: str, expected_hash: str) -> bool:
    current = sha256_file(path)
    return current == expected_hash

