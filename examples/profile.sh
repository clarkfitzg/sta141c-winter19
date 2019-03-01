# Profiling our python script

DATAFILE=/scratch/transaction.zip
ONLY_COLUMNS=amt_agency.csv
FIRST_DIGIT=first_digits.csv
AGENCY=18
AMT=8

unzip -p ${DATAFILE}  |
    cut -d , -f ${AGENCY},${AMT} |
    head -n 100000 > ${ONLY_COLUMNS}

# Interesting
python3 -m cProfile -s tottime first_char_first_col.py ${ONLY_COLUMNS} ${FIRST_DIGIT}


unzip -p ${DATAFILE}  |
    cut -d , -f ${AGENCY},${AMT} |
    python3 -m cProfile -o pyprof.out first_char_last_column.py > test.txt
    #Rscript first_char_last_column.R > test.txt
    
# Don't unzip, just csv file
cut -d , -f ${AGENCY},${AMT} /scratch/transaction.csv |
    python3 -m cProfile -o pyprof.out first_char_last_column.py > test.txt
    #Rscript first_char_last_column.R > test.txt
