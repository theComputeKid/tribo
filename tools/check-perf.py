#!/usr/bin/python3
"""
Checks the bench comparison JSON
- Throws error if benchmakrs regressed.

Copyright (c) 2024 theComputeKid
"""
import argparse, json


def __checkResults(results):

    threshold = 0.1
    regression: bool = False

    for result in results:
        name = result["name"]
        time = result["measurements"][0]["time"]
        if time > threshold:
            print(f"Regression: {name}, time: {time}")
            regression = True

    if regression:
        raise ValueError(f"Regressions detected.")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="Bench output JSON file path.")
    args = parser.parse_args()
    jsonFile: str = args.file
    print(f"Bench output JSON: {jsonFile}")
    with open(jsonFile) as f:
        results = json.load(f)
    __checkResults(results)


if __name__ == "__main__":
    main()
