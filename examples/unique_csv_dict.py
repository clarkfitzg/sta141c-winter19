#!/usr/bin/env python3
"""
Write the set of unique elements in a column to a file.
Assumes that this set fits in memory.
Usage:

    $ python3 unique_csv_dict.py data.csv column_name > values.txt
"""

import csv
import sys

fname, column = sys.argv[1: ]

with open(fname) as f:
    reader = csv.DictReader(f)
    result = {r[column] for r in reader}

output = "\n".join(result)

sys.stdout.write(output)
