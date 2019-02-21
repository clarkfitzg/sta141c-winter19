#!/usr/bin/env python3
"""
For the last column, print only the first character.
Usage:

    $ echo "100,200" | python3 first_char_last_column.py

Should print "100,2"
"""

import csv
from sys import stdin, stdout


def main():
    reader = csv.reader(stdin)
    writer = csv.writer(stdout)

    for row in reader:
        row[-1] = row[-1][0]
        writer.writerow(row)


if __name__ == "__main__":
    main()
