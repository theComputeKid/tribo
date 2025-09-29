#!/usr/bin/python3
"""
Check all commit messages b/w two hashes:
- Ensure title is 72 characters or less.

Copyright (c) 2024 theComputeKid
"""
import argparse, subprocess


def __numCharacterCheck(msg: str):
    msgLen = len(msg)
    if msgLen >= 72:
        raise ValueError(f"Message must be 72 characters or less. Got: {msgLen}")
    else:
        print(f"NumCharacters: {msgLen}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("sha", help="Commit SHA")
    args = parser.parse_args()
    sha: str = args.sha

    messages = subprocess.run(
        ["git", "show", "-s", "--format=%B", sha],
        capture_output=True,
        text=True,
    ).stdout

    header = messages.splitlines()[0]
    print(f"Header: {header}")
    __numCharacterCheck(header)


if __name__ == "__main__":
    main()
