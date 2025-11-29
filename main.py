#!/usr/bin/env python3

from core.hasher import load_baseline, verify_file
from core.logger import log

BASELINE_FILE = "/opt/doberman/baseline.db"
LOGFILE = "/var/log/doberman/doberman.log"


def main():
    log("Doberman integrity scan started")

    baseline = load_baseline(BASELINE_FILE)

    for path, expected_hash in baseline.items():
        verified = verify_file(path, expected_hash)

        if verified:
            log(f"OK: {path}")
        else:
            log(f"ALERT: {path} has been modified!")

    log("Doberman scan finished\n")


if __name__ == "__main__":
    main()
    