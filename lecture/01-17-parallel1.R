## ## Announcements

## - The homework took me between 30 minutes to 1 hour to run in serial.
##  Budget your time accordingly to complete this assignment.

## ## Review

## Last class I introduced debugging techniques.

## Call `debug` on a function to enter the browser when that function is called.

debug(zapsmall)

x = c(1, 1e-12)

zapsmall(x)

undebug(zapsmall)

## Set `options(error = recover)` to enter the debugger and directly examine the state of the program when it failed.

options(error = recover)

zapsmall(x, digits = numeric())

## ## Introduction to Parallelism

## (Slides)[https://docs.google.com/presentation/d/1qmnBM6hwl-nu2wf9sPF8pIxWEtlPd-6O2DH7aq0CZWU/edit?usp=sharing]

## We're going to see several more models for parallelism in this class.
## What I'm going to show you today is local parallelism without shared memory.
## 'local' means we're using several processors on one physical machine, probably your laptop.
## 'no shared memory' means that the worker processes operate completely independently, so we sometimes need to explicitly share data between them.
## I'm showing you this first because it will work on any computer, including Windows.
## Other common models for parallelism are mostly refinements and variations on this basic idea.

## People seem to think that basic parallelism is harder than it is.
## There are many add on frameworks and packages that try to make life easier.
## Everything you need comes included in the recommended `parallel` package with R.

## __Question__: Why use a recommended package?
## 1. Code and API is stable
## 2. Well tested and supported
## 3. It will always be there for you

## Some working definitions:
## - manager: the process that assigns and collect work
## - worker / node: the process that performs the work
## - cluster: the collection of worker nodes

## We'll revisit these terms when we go to the actual remote compute cluster.

library(parallel)

cls = makeCluster(2L, type = "PSOCK")

cls
## This shows what kind of cluster this is, and where it is.

## When we're done using the cluster, best practice is to turn it off.
## If we forget, then R will do this for us later when we quit R.
stopCluster(cls)

cls = makeCluster(2L, type = "PSOCK")

## ### Basic usage

x = 1:4

## This is the serial way of using lapply
lapply(x, seq)

## We can copy and paste it, and then convert it to parallel.
parLapply(cls, 1:4, seq)

## It gives us the same answer.

## But what if we wrote our code in a for loop?
## Warning: what I'm about to show you is _hideously_ inefficient.
result = list()
for(i in seq_along(x)){
    result[[i]] = seq(x[[i]])
}

## Compare and contrast functional vs procedural styles.
## `lapply` is functional, `for` loop is procedural.

## Is it difficult to convert embarrassingly parallel code to parallel?
## Not if you're writing in a functional style, using idiomatic R.
## R is a functional language- we pass functions around and rarely see side effects, which makes parallelism mostly straightforward.
## This is why I like using the recommended packages.

## What exactly happened?
## The manager, the local process, split the data 1:4 into groups for each worker.

clusterSplit(cls, x)

## It sent one group to each worker node, along with the function `seq`,  and asked it to evaluate it.

## One possible approach to synchronization is to just send everything to the workers.
## What's wrong with this?
## If there are large objects in your workspace this will be inefficient.

## __Question__: If you want to b
