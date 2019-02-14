
## Questions

"Not enough space left on device."

Can mean that the disk is full.

How to use sftp?

Question 2.2 asks if the agency ID's are matching?
Can we use R?

Sure, use whatever you want.
Just compare the ID's
Find out how many are in one but not the other.


## Review

Some anti patterns

```{r}
# What's wrong?
# y is a global variable, and we didn't need to do this.

fbad = function(x) x + y

y = 10

fbad(1)

fgood = function(x, y) x + y

fgood(1, y)

library(codetools)

codetools::checkUsage(fbad)

codetools::checkUsage(fbad, all = TRUE)

codetools::checkUsage(fgood)

```

lintr is another package that will help with this.


## Project

Ideas for questions:

- Predict future spending
- Who gets the most money?
- Evolution of who gets the most money.
- Border Security, where is it going?
  How has it been spent in the past?
  Have the priorities changed?
- Party preferences and spending.
- Trends around each recipient receiving money.
- Wildfires, funding patterns around disasters

## Technology

big = rnorm(1e8)

print(object.size(big), units = "MB")

Sys.getpid()

library(parallel)

cls = makeCluster(2L, type = "FORK")

clusterEvalQ(cls, Sys.getpid())

The great thing:
We can use the big object from the children processes

big[1]

clusterEvalQ(cls, big[1])

## Copy on Write

clusterEvalQ(cls, big[1] <- 100)

# Why 1.5 GB?

It made 2 copies!

clusterEvalQ(cls, gc())

stopCluster(cls)

# More convenient ways:

x = 1:5

lapply(x, seq)

mclapply(x, seq)

# How many workers does mclapply use?


mclapply(x, seq, mc.cores = 2L)

# pvec does something similar but more efficient for a vectorized function

sin(x)

sapply(x, sin)

pvec(x, sin)

Running a command asynchronously?

job = mcparallel(sin(x))

result = mccollect(job)
