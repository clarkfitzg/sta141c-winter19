# For the last column, print only the first character.
# Usage:
# 
#     $ echo "100,200" | Rscript first_char_last_column.R
# 
# Should print "100,2"

# Example adding profiling:
Rprof()

input = file("stdin")
open(input)

output = stdout()

chunk_size = 1e5L

# There are several possible permutations of this while loop, for example:
# 1. do the reading and assignment inside the while call
# 2. try to read and catch the error

lines = readLines(input, n = chunk_size)

while(0 < length(lines)){
# If this gets too complicated we could pull each step out into it's own function

    # 1. Parse raw data
    chunk = read.table(text = lines, sep = ",")

    # 2. Process
    lastcol = ncol(chunk)
    # Replace the last column of strings with the first character
    chunk[, lastcol] = substring(chunk[, lastcol], 1L, 1L)

    # 3. Write
    write.table(chunk, output, sep = ",", quote = FALSE, col.names = FALSE, row.names = FALSE)

    # 4. Fetch more raw data
    lines = readLines(input, n = chunk_size)
}

# Idea: demonstrate map reduce on a table.
