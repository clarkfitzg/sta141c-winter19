#!/usr/bin/env python3
"""
Write the set of unique elements in a column to a file.
Assumes that this set fits in memory.
To get the unique set of values in column 19 of data.csv:

    $ python3 unique_csv_dict.py data.csv 19
"""

import csv
import sys


fname, column = sys.argv[1: ]
column = int(column) - 1 # back to 0 based indexing.

with open(fname) as f:
    reader = csv.reader(f)
    result = {r[column] for r in reader}

output = "\n".join(result)

sys.stdout.write(output)
