# Profiling our python script

DATAFILE=/Users/clark/data/transaction.zip
AGENCY=18
AMT=8

cut --delimiter=, --fields=${AGENCY},${AMT} ${DATAFILE} |
    head -n 100000 > amt_agency.csv
