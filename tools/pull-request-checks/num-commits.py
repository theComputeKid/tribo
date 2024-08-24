#!/usr/bin/python3
import argparse, re


# * Ensuring everything fixes an issue.
def __numCheck(num: int):
    if num != 1:
        raise ValueError(
            f"Only a single commit is allowed. Please amend and force push commits."
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
