

# Suppose I wanted to pass arbitrary arguments into read.table. How? ...
read_chunk = function(file, sep = ",", nrows = 1e5L)
{
    read.table(file, sep = sep, nrows = nrows)
}


input = file("stdin")

output = stdout()


chunk = read_chunk(input)
lastcol = ncol(chunk)

# If this got complicated we could pull the process and write steps out into their own functions, like the read one.

while(0 < nrow(chunk)){
    # Replace the last column of strings with the first character
    chunk[, lastcol] = substring(chunk[, lastcol], 1L, 1L)
    write.table(chunk, output, sep = ",")
}

# Idea: demonstrate map reduce on a table.
