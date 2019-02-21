import csv
import sys

fname, column = sys.argv[1: ]
#column = int(column) - 1 # back to 0 based indexing.

with open(fname) as f:
    reader = csv.DictReader(f)
    result = {r["funding_agency_id"] for r in reader}

sys.stdout.writelines(result)
