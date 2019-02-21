# To get 3 cpus on node c0-19:
# $ srun --pty -p staclass -w c0-19 -c 3 bash -i

#DATAFILE="/scratch/transaction.csv"
DATAFILE="../data/transaction100.csv"
AGENCY=18

# Find the set of unique funding agencies.

# real    8m48.701s
# user    8m18.437s
# sys     0m46.286s

# This version sorts 100 million numbers :(
time cut --delimiter=, --fields=${AGENCY} ${DATAFILE} |
    sort |
    uniq > funding_agency_set.txt


# This version collects the set in one pass :)
time cat ${DATAFILE} |
    tail -n +2 |                            # Drops first line
    cut --delimiter=, --fields=${AGENCY} |  # Select the column of interest
    python3 unique.py |
    cat > funding_agency_set.txt


# Without Uuoc
# I know that IO wasn't the bottleneck because when I checked the output of 'top'
# I saw that one of the commands 'cut' was using nearly 100% CPU. 
# If IO was the bottleneck then it would be using less.

# real    7m27.931s
# user    6m40.766s
# sys     0m42.025s
time cut --delimiter=, --fields=${AGENCY} ${DATAFILE} |
    python3 unique.py > funding_agency_set.txt


# With csv.reader
# real    27m28.049s
# user    26m27.384s
# sys     0m45.181s

# With csv.DictReader
# real    54m0.713s
# user    52m4.073s
# sys     0m47.538s

time python3 unique2.py ${DATAFILE} ${AGENCY} > funding_agency_set.txt

