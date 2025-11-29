#!/usr/bin/env python3

import time

def log(message: str):
    timestamp = time.strftime("[%Y-%m-%d %H:%M:%S]")
    with open(LOGFILE, "a") as f:
        f.write(f"{timestamp} {message}\n")
