DATAFILE="/home/clark/data/transaction.zip"
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
unzip -p ${DATAFILE} |
    tail -n +2 |                            # Drops first line
    cut --delimiter=, --fields=${AGENCY} |  # Select the column of interest
    python3 unique.py |
    cat > funding_agency_set.txt
