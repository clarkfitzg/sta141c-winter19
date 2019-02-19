Topics:

- Collectively think about questions for project
- Tools for analyzing code
- Shared memory parallel programming- could be helpful for bootstrapping assignment

Announcements:

- I'll hold a little extra office hours after class today. Siteng has office hours tomorrow, so I don't think it's necessary to be up at night.
- Video is uploaded
- Scores are available for half of participation and hw3
- Project proposals due next week, today is a good time to find partners- think about what tech you want to use.

Reading:

- [R parallel vignette](https://stat.ethz.ch/R-manual/R-devel/library/parallel/doc/parallel.pdf)
- [R parallel fork documentation](https://stat.ethz.ch/R-manual/R-devel/library/parallel/html/mcfork.html)
- [CRAN high performance and parallel computing task view](https://cran.r-project.org/view=HighPerformanceComputing)

Terms:

- __process__ A single running program
- __fork__ When the operating system duplicates a process
- __parent__ The original process
- __child__ The newly created process

A single process can have multiple __threads__ executing instructions at the same time.
R is generally not thread safe, and we're not talking about threads today.

Show processes in activity monitor.
My Mac has 581 processes running a total of 1966 threads as I type this.

## Project

Use any technology you want.

Let's discuss- what are some interesting questions we could ask given this data set?

Who is dying to use particular technologies?
Raise hands, and look around, so that you can form groups based on mutual interest.


## Review

There are many ways that code can be good or bad.
Often people don't even agree on what these are.
[Anti patterns](https://en.wikipedia.org/wiki/Anti-pattern#Software_engineering)

Here are a couple ways to check your code for problems.

This code has a problem: it unnecessarily uses a global variable `y`.

```{r}
fbad = function(x) x + y
```

To fix it we need to pass `y` as a parameter in the function, possibly with a default value.

```{r}
fgood = function(x, y) x + y
```

The codetools package has tools to help check your code.

```{r}
# Shows we have a global variable
codetools::checkUsage(fbad)

# No messages
codetools::checkUsage(fgood)
```

The lintr package is also worth checking out.


## Shared Memory Parallel Processing

In an earlier lecture we covered the simple parallel model where each worker is independent.

UNIX type operating systems provide a feature called a process `fork`.
This creates a copy of the currently running process, including all state and variables.
It's fast because it can just reference the original data, without necessarily making a physical copy.

Windows can't do this.

The software is in the recommended parallel package.

Let's demonstrate sharing a large object among several workers.

Watch what happens in the activity monitor as I do this.

```{r}
big = rnorm(1e8)

print(object.size(big), units = "MB")
```

In the activity monitor we see a single R process taking up a bunch of memory.

```{r}
library(parallel)

cls = makeCluster(2L, type = "FORK")
```

Now there are 2 more R processes that are children of this process, and we can use them as we learned before.

```{r}
Sys.getpid()

clusterCall(cls, Sys.getpid)
```

The wonderful thing is that we can access the big object without copying it.

```{r}
clusterEvalQ(cls, big[1])
```

This worked, which shows that each of the 2 child processes has access to the `big` object and can read that memory.
Looking at the activity monitor for these two processes we see that they still use only a minimal amount of memory- on the order of 5 MB for an R interpreter process.

Similarly, all the children have all the same libraries open and will generally behave in the same way.


### Copy on Write

The children get a copy of the parent process at the moment that the child is created.

The objects are only shared until the parents or the children change them.
The changes are 'copy on write', which are R's normal semantics.

If the parent changes after the children exist, then the children do not see that change.

If the children write to the objects then they will get a copy of the object.

```{r}
clusterEvalQ(cls, big[1] <- 100)
```

Now each of the children seem to be using 1.5 GB.
Question: What is going on?
Answer: This is about twice the size of the object.
Which means R copied the object once from the parent to the child, and then copied it again in the child when it made the change.
Eventually the spare copy will be garbage collected, and R can release memory back to the OS.

```{r}
clusterEvalQ(cls, gc())
```

This relates to what we've been doing on the cluster, because one of the SLURM parameters is to specify how much memory a job will use.
By the way, the best way to figure this out is to just monitor a script as it runs.


### More Convenient Options

The commands above explicitly manage the cluster.
It's better to avoid all this if possible, so here are some more convenient ways to use the underlying fork.

We can simply swap in `parallel::mclapply` for `lapply`:

```{r}
x = 1:5

y = lapply(x, seq)

y2 = parallel::mclapply(x, seq, mc.cores = 2L)
```

`parallel::mclapply` does the equivalent of:

- set up a local cluster with `mc.cores` workers
- distribute the `lapply` across workers
- receive the results
- shut down and remove the cluster

It's convenient. 
If the `lapply` in your program is the bottleneck, then this can be a quick and easy win.
`parallel::pvec` offers a similar option for vectorized functions.

If you just want to run a single command asynchronously (in the background) in parallel you can do that with `mcparallel` followed by `mccollect`.

```{r}
job = mcparallel(1:5)

# ... do other stuff...

result = mccollect(job)
```


### Side note

The command line and pipes are useful for more than just processing data.
We can also use it to control the computer.
For example, to kill the children processes from the command line:

```{bash}
$ pgrep -P 8261 | xargs kill
```

Here's what's going on in this command:

- `pgrep -P 8261` prints the processes that are children of process 8261 to `stdout`.
- `kill 1234` will terminate process 1234. The `kill` command accepts process id's as arguments, but it cannot read them from `stdin`.
- `xargs` takes `stdin` and makes it appear as an argument that we explicitly passed.

`xargs` is another example of the flexibility and utility of the UNIX philosophy.


## Memory mapping

Another approach to sharing memory among processes is to treat the disk as if it were memory.
This also allows us to operate on objects that are larger than memory.
It's generally slower, because disk is slower than memory, so we only use it when we have to.

```{r}
library(bigmemory)

m = filebacked.big.matrix(10, 10
    , backingfile = "m.bin"
    , descriptorfile = "m.bin.desc"
)
```

It's better to share a read only copy, but we can write and see the changes if we need to.
The problem is we need to synchronize all the workers, and this can be very painful.

```{r}
m[1, 1] = 100

m[1, 1]

# Write the changes to disk.
flush(m)
```

Then, from another R process we can call: 

```{r}
m = attach.big.matrix("m.bin.desc")

m[1, 1]

m[1, 1] = 200
```

And notice how the other processes pick up the result.

There are other solutions out there - hdf5 comes to mind.
