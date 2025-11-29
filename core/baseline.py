#!/usr/bin/env python3

import hashlib
import os


CONFIG_FILE = "/opt/doberman/doberman.config"
BASELINE_FILE = "/opt/doberman/baseline.db"

def sha256_file(path: str) -> str:
    h = hashlib.sha256()
    try:
        with open(path, "rb") as f:
            while chunk := f.read(8192):
                h.update(chunk)
        return h.hexdigest()
    except FileNotFoundError:
        return None


def create_baseline():
    if not os.path.exists(CONFIG_FILE):
        print(f"Config file {CONFIG_FILE} does not exist.")
        return

    with open(CONFIG_FILE) as config, open(BASELINE_FILE, "w") as out:
        for line in config:
            file_path = line.strip()
            if not file_path:
                continue

            file_hash = sha256_file(file_path)
            if file_hash:
                out.write(f"{file_hash} {file_path}\n")
                print(f"Added: {file_path}")
            else:
                print(f"Skipped (not found): {file_path}")

    print(f"Baseline created at {BASELINE_FILE}")

if __name__ == "__main__":
    create_baseline()
