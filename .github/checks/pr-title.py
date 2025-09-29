#!/usr/bin/python3
"""
Check title of a pull request:
- Ensure title is 72 characters or less.

Copyright (c) 2024 theComputeKid
"""
import argparse


def __numCharacterCheck(msg: str):
    msgLen = len(msg)
    if msgLen >= 72:
        raise ValueError(f"Message must be 72 characters or less. Got: {msgLen}")
    else:
        print(f"NumCharacters: {msgLen}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("msg", help="Commit message to check.")
    args = parser.parse_args()
    msg: str = args.msg
    print(f"msg: {msg}")
    __numCharacterCheck(msg)


if __name__ == "__main__":
    main()
