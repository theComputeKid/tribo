#!/usr/bin/python3
"""
Check body of a pull request:
- Ensure "Fixes #XXX" is present in the body.

Copyright (c) 2024 theComputeKid
"""
import argparse, re


# * Ensuring everything fixes an issue.
def __fixCheck(msg: str):
    if not re.search(r"Fixes #[0-9]+", msg):
        raise ValueError(f"One of the msg lines must contain 'Fixes #XXX'")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("msg", help="Commit message to check.")
    args = parser.parse_args()
    msg: str = args.msg
    print(f"msg: {msg}")
    __fixCheck(msg)


if __name__ == "__main__":
    main()
