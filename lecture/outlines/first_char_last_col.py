#!/usr/bin/env python3
"""
(Writing the docstring focuses our minds)

For the last column, write only the first character.

Example:

$ echo "a,100" | python3 first_char_last_col.py

Should produce "a,1"
"""

import csv
import sys


reader = csv.reader(sys.stdin)
writer = csv.writer(sys.stdout)
for row in reader:
    row[-1] = row[-1][0] 
    writer.writerow(row)
