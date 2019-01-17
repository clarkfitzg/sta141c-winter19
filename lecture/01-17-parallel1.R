## ## Announcements

## - The homework took me between 30 minutes to 1 hour to run in serial.
##  Budget your time accordingly to complete this assignment.
## - Memory usage plot
## - Office hours today in 4th floor MSB

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
## Each workers evaluates `lapply(x_group, seq)` on their particular `x_group`, and then sends the result back to the manager.
## Once the manager has collected all the results from all the workers it returns the result.
## This is all overhead that the serial model doesn't have.

## One problem is that this overhead of setting up and moving data takes time.
## This is why parallel code is often slower than serial code.

library(microbenchmark)

microbenchmark(lapply(x, seq))

microbenchmark(parLapply(cls, 1:4, seq))

## In this case the parallel version was about 30 times slower than the serial version.
## This is why we don't use parallelism until we're pretty sure that we need it.
## In a future lecture we'll talk about profiling and benchmarking.

## ## Preparing the workers

## The most common error that programmers make is that they do not prepare the workers to do the work.

## Initially, the workers have nothing in their global workspace:

# Local:
ls(envir = globalenv())

# Same code called on each worker node:
clusterCall(cls, ls, envir = globalenv())

# `clusterCall` works just like `do.call`, only it calls the function on a cluster.

preprocess1 = function(x)
{
    tolower(x)
}

## a string, complete with a subliminal message.
strings = c("Ask questions", "If you don't understand.")

## `parLapply` will send a single function over.
parLapply(cls, strings, preprocess1)

## This works fine.
## Lets make it a little more complex by adding another step.

civilize = function(x) paste("Please", x, "Thank you.")

preprocess2 = function(x)
{
    result = tolower(x)
    civilize(result)
}

## Works fine locally
lapply(strings, preprocess2)

## The problem is that the workers that already exist do not know about the new object I just created- the function `civilize`.
## Indeed, how could they possibly know?
## They do not share memory or any resources.
## The only connection they have is a pipe to send data back and forth.
## Let's make sure they don't know:

clusterCall(cls, ls, envir = globalenv())

## Of course, `parLapply` could be very smart.
## It could look at the code for `preprocess2` and see that I use the function `civilize`, and somehow magically know that this is a function that I wrote, and that I actually mean to export and use it.
## If `parLapply` is that smart, then this should work, just like it did locally.
## If it doesn't, then it should return an error, saying it can't find the function `civilize`.  
## Make your predictions!
parLapply(cls, strings, preprocess2)

## It's not that smart, not yet anyways.
## This is the sort of thing I think about in my research, how to make the code smarter.

## We need to explicitly send the object over.
clusterExport(cls, "civilize")

## Now it's there:

clusterCall(cls, ls, envir = globalenv())

## The general problem is to synchronize state so that the workers will behave as we want them to.
## For example, we might load a library locally.

library(tm)

preprocess3 = function(x)
{
    result = tolower(x)
    stemDocument(result)
}

lapply(strings, preprocess3)

## Will the workers load the tm package if the manager loads it?
## I'm showing you a meta-technique here: pose a small question that will strengthen your mental model of how this all works.
## This is 
## If workers do load the tm package, then this will work.

parLapply(cls, strings, preprocess3)

## Didn't work. Which means that we actually need to load the library.

## `clusterEvalQ` evaluates arbitrary code on the cluster:

clusterEvalQ(cls, library(tm))

## Now it should work.

parLapply(cls, strings, preprocess3)

## The code is exactly the same.
## It will only run if the workers are ready.
## Furthermore, it will only give you the right answer if all the objects are as you expect them to be.

## One possible approach to synchronization is to just send everything to the workers.
## What's wrong with this?
## If there are large objects in your workspace it will be inefficient.

## ## Easy way

## One easy way to synchronize things is to just write a script that contains all your functions and libraries.
## I've put such a script in `preprocess.R`.
## Let's start fresh with a new cluster and see it in action.

stopCluster(cls)

cls = makeCluster(2L, type = "PSOCK")

clusterCall(cls, source, "preprocess.R")

## Now it all works great.

parLapply(cls, strings, preprocess3)


