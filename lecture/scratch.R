# f is a file connection
## It started out 'closed'.
## Let's open it up and get some data.
open(f)

## Every time we run this line it feeds us the next `n = 2` lines from the connection.
readLines(f, n = 2L)


