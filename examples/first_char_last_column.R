# For the last column, print only the first character.
# Usage:
# 
#     $ echo "100,200" | Rscript first_char_last_column.R
# 
# Should print "100,2"

input = file("stdin")
open(input)

output = stdout()

# There are several possible permutations of this while loop, for example:
# 1. start with reading a chunk outside the loop
# 2. try to read and catch the error

while(TRUE){
# If this gets too complicated we could pull each step out into it's own function

    # 1. Read
    chunk = read.table(input, sep = ",", nrows = 1e5L)

    # 2. Process
    lastcol = ncol(chunk)
    # Replace the last column of strings with the first character
    chunk[, lastcol] = substring(chunk[, lastcol], 1L, 1L)

    # 3. Write
    write.table(chunk, output, sep = ",", quote = FALSE, col.names = FALSE, row.names = FALSE)

    # 4. No more input
    if(!isIncomplete(input)) break
}

# Idea: demonstrate map reduce on a table.
