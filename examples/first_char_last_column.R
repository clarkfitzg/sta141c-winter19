# For the last column, print only the first character.
# Usage:
# 
#     $ echo "100,200" | Rscript first_char_last_column.R
# 
# Should print "100,2"

input = file("stdin")
open(input)

output = stdout()


while(isIncomplete(input)){
# If this gets too complicated we could pull each step out into it's own function

    # 1. Read
    chunk = read.table(file, sep = ",", nrows = 1e5L)

    # 2. Process
    lastcol = ncol(chunk)
    # Replace the last column of strings with the first character
    chunk[, lastcol] = substring(chunk[, lastcol], 1L, 1L)

    # 3. Write
    write.table(chunk, output, sep = ",", quote = FALSE, col.names = FALSE, row.names = FALSE)
}

# Idea: demonstrate map reduce on a table.
