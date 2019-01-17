## Announcements

- The homework took me between 30 minutes to 1 hour to run in serial.
 Budget your time accordingly to complete this assignment.
- Memory usage plot
- Office hours today in 4th floor MSB

## Review


Call `debug` on a function to enter the browser when that function is called.

```r
debug(zapsmall)

x = c(1, 1e-12)

zapsmall(x)

undebug(zapsmall)
```

Set `options(error = recover)` to enter the debugger upon failure.

```r
options(error = recover)

zapsmall(x, digits = numeric())
```

## Introduction to Parallelism

(Slides)[https://docs.google.com/presentation/d/1qmnBM6hwl-nu2wf9sPF8pIxWEtlPd-6O2DH7aq0CZWU/edit?usp=sharing]

Today: Local parallelism without shared memory

Works on any machine including Windows

__Question__: Why use a recommended package?
1. Code and API is stable
2. Well tested and supported
3. It will always be there for you

working definitions:
- manager: the process that assigns and collect work
- worker / node: the process that performs the work
- cluster: the collection of worker nodes


Turn cluster off and on

```r
library(parallel)

cls = makeCluster(2L, type = "PSOCK")

stopCluster(cls)

cls = makeCluster(2L, type = "PSOCK")
```

Basic usage, conversion from serial to parallel

```r
x = 1:4

lapply(x, seq)

parLapply(cls, 1:4, seq)
```

for loops, yuck!
Warning: what I'm about to show you is _hideously_ inefficient.

```r
result = list()
for(i in seq_along(x)){
    result[[i]] = seq(x[[i]])
}
```

Compare and contrast functional vs procedural styles.
`lapply` is functional, `for` loop is procedural.

__Question__ Is it difficult to convert embarrassingly parallel code to parallel?

What exactly happened?
Split, send, eval, receive

```r
clusterSplit(cls, x)
```

Parallel code is often slower than serial code.

```r
library(microbenchmark)

microbenchmark(lapply(x, seq))

microbenchmark(parLapply(cls, 1:4, seq))
```

The *most common error* is that the workers are not ready.

Initially, the workers have nothing in their global workspace.

```r
# Local:
ls(envir = globalenv())

do.call(ls, args = list(envir = globalenv()))

# Same code called on each worker node:
clusterCall(cls, ls, envir = globalenv())

# `clusterCall` works just like `do.call`, only it calls the function on a cluster.

preprocess1 = function(x)
{
    tolower(x)
}

strings = c("Ask questions", "If you don't understand.")
```

`parLapply` will send a single function over.

```r
parLapply(cls, strings, preprocess1)
```

Lets make it a little more complex by adding another step.

```r
civilize = function(x) paste("Please", x, "Thank you.")

preprocess2 = function(x)
{
    result = tolower(x)
    civilize(result)
}

lapply(strings, preprocess2)
```

Do the workers know about this function I just wrote?

```r
clusterCall(cls, ls, envir = globalenv())
```

How smart is `parLapply`?

```r
parLapply(cls, strings, preprocess2)
```

Explicitly send the object over

```r
clusterExport(cls, "civilize")

clusterCall(cls, ls, envir = globalenv())

parLapply(cls, strings, preprocess2)
```

The general problem is to synchronize state

```r
library(tm)

preprocess3 = function(x)
{
    result = tolower(x)
    stemDocument(result)
}

lapply(strings, preprocess3)
```

__Question__ Will the workers load the tm package if the manager loads it?

Important meta-technique: pose a small question that will strengthen your mental model of how this all works.

```r
parLapply(cls, strings, preprocess3)
```

`clusterEvalQ` evaluates arbitrary code on the cluster:

```r
clusterEvalQ(cls, library(tm))

parLapply(cls, strings, preprocess3)
```

The code is exactly the same.
It will only run if the workers are ready.

__Question__ Why not just send everything to the workers every time?

__Question__ What is a good way to prepare workers?

How do we normally do it?

Write a script!

```r
stopCluster(cls)

cls = makeCluster(2L, type = "PSOCK")

clusterCall(cls, source, "preprocess.R")

parLapply(cls, strings, preprocess3)
```
