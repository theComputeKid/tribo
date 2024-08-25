#!/usr/bin/python3
"""
Check number of commits in a pull request:
- Ensure only 1 commit per PR.

Copyright (c) 2024 theComputeKid
"""
import argparse


def __numCheck(num: int):
    if num != 1:
        raise ValueError(
            f"Only a single commit is allowed. Please sqaush and force push commits."
        )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("num", type=int, help="Commit message to check.")
    args = parser.parse_args()
    num: int = args.num
    print(f"num: {num}")
    __numCheck(num)


if __name__ == "__main__":
    main()
