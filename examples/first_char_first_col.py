import csv
import sys

infile_name, outfile_name = sys.argv[1: ]

with open(infile_name) as f:
    with open(outfile_name, "w") as outfile:
        writer = csv.writer(outfile)
        reader = csv.reader(f)
        for row in reader:
            row[0] = row[0][0] 
            writer.writerow(row)
