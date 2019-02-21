# To get 3 cpus on node c0-19:
# $ srun --pty -p staclass -w c0-19 -c 3 bash -i

DATAFILE="/scratch/transaction.csv"
AGENCY=18

# Find the set of unique funding agencies.

# This version sorts 100 million numbers :(
unzip -p ${DATAFILE} |
    tail -n +2 |                            # Drops first line
    cut --delimiter=, --fields=${AGENCY} |  # Select the column of interest
    sort |
    uniq |
    cat > funding_agency_set.txt


# This version collects the set in one pass :)
time cat ${DATAFILE} |
    tail -n +2 |                            # Drops first line
    cut --delimiter=, --fields=${AGENCY} |  # Select the column of interest
    python3 unique.py |
    cat > funding_agency_set.txt


# Without Uuoc
time cut --delimiter=, --fields=${AGENCY} ${DATAFILE} |
    python3 unique.py > funding_agency_set.txt

