import csv
import sys

fname, column = sys.argv[1: ]
column = int(column)

with open(fname) as f:
    reader = csv.reader(f)
    result = {r[column] for r in reader}

sys.stdout.writelines(result)
