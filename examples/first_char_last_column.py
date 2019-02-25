#!/usr/bin/env python3
"""
For the last column, print only the first character.
Usage:

    $ printf "100,200\n0,\n" | python3 first_char_last_column.py

Should print "100,2\n0,"
"""

import csv
from sys import stdin, stdout


def main():
    reader = csv.reader(stdin)
    writer = csv.writer(stdout)

    for row in reader:
        try:
            row[-1] = row[-1][0]
        except IndexError:
            pass
        writer.writerow(row)


if __name__ == "__main__":
    main()
