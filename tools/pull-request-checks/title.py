#!/usr/bin/python3
import argparse, re


# * Ensuring a line limit.
def __summaryCheck(msg: str):
    summary = msg.partition("\n")[0]
    msgSummaryLen = len(summary)
    if msgSummaryLen >= 50:
        raise ValueError(f"Message summary must be less than 60. Is: {msgSummaryLen}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("msg", help="Commit message to check.")
    args = parser.parse_args()
    msg: str = args.msg
    print(f"msg: {msg}")
    __summaryCheck(msg)


if __name__ == "__main__":
    main()
