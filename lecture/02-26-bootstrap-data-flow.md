Possible topics:

- Bootstrap
- Reusable software in R / Python
- R, Numpy `stdin`
- Profiling
- Debugging in python with -m
- IO bound vs. CPU bound
- Splitting, map reduce
- error handling, better to ask forgiveness than to ask permission, look before you leap

Later:

- Numba compilation

## Announcements

- Last class I asked you nicely to clean up the `/scratch` directories on the worker nodes.
  Do it by tonight or forfeit points on the last assignment.
  That's users: s141c-54, 40, 48, 53
  Leave whatever you want in your home directory.
- please don't request excessive resources on the cluster, because then others cannot use them.
  In particular, on the `staclass` partition please use 1 task at a time with up to two CPUs.  
  `#SBATCH --cpus-per-task=2`
- For the homework, It should take 1 or 2 hours to collect the counts of the first digits, and quite possibly less.


## Reading

- [Original bootstrap paper](https://link.springer.com/chapter/10.1007/978-1-4612-4380-9_41)
- [Bootstrap paper on massive data (little bag of bootstraps)](https://arxiv.org/abs/1112.5016)
- [Advanced R profiling chapter](http://adv-r.had.co.nz/Profiling.html)
- [Blog: 3 billion rows with R](http://clarkfitzg.github.io/2017/10/31/3-billion-rows-with-R/)


## bootstrap

This is an example of using the bootstrap.

The central limit theorem gives the distribution of the sample mean.
If the underlying distribution has standard deviation `sigma`, then the sample mean will have standard error `sigma / sqrt(n)`.
Let's check if the bootstrap sample mean has a similar standard error.

```{r}
set.seed(8390)
n = 1000L
x = rnorm(n)

sigma = 1
se_theory = sigma / sqrt(n)

b = 100L

# A single bootstrap sample:
x_star_1 = sample(x, size = n, replace = TRUE)

# They're not the same.
mean(x)
mean(x_star_1)

xbar_boot = replicate(b, mean(sample(x, size = n, replace = TRUE)))

se_boot = sd(xbar_boot)

se_theory
se_boot
```

They are reasonably close.

The idea is that the empirical distribution of the statistic on the bootstrap samples is close to the actual distribution of the statistic.

```{r}
hist(xbar_boot, freq = FALSE)

curve(dnorm(x, sd = se_theory), add = TRUE)
```

There are extensions of the bootstrap idea, see the reading list.


## Counting

Hopefully you're not writing a program to do counting.
There are many useful programs that will count for you.

From the command line, assuming that the data is sorted:

```{bash}
$ echo "a,1
a,1
a,1
a,2
a,2
b,1
b,1
b,5
b,5
b,5
b,5" > data.csv

$ uniq -c data.csv
```

We can feed this into R in a couple different ways.

Easiest is to just count everything with `table`.
This assumes that `data.csv` will fit in memory, which may not be the case with this data set.

```{r}
d = read.table("data.csv", sep = ",")
counts = table(d)
```

We can also pipe the output from the shell command.

```{r}
p = pipe("uniq -c data.csv")
counts = read.table(p)
```

This requires some subsequent massaging to get it into a form we can work with.

Python also has the ability to count things.

```{python}
from collections import Counter
import csv

f = open("data.csv")
rows = (tuple(r) for r in csv.reader(f))

c = Counter(rows)
```


## Monitoring Performance

Let's play around on the cluster.

```{bash}
squeue
#             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
#           2067452  staclass      hw5 s141c-49  R   20:00:31      1 c0-10
#           2067463  staclass  hw5_try s141c-31  R   18:29:49      1 c0-10
```

Accounts 31 and 49 are currently running jobs.
They're taking 20 hours, which means they're not being efficient, but that's how you learn.

```{bash}
# Login to node c0-19
srun --pty -p staclass --nodelist c0-19 bash -i

# I'm going to request 5 CPUs on a particular machine for the purpose of this experiment.
# You should use 2 
srun --pty -p staclass --nodelist c0-19 -c 5 bash -i
```

On my mac I've been using the activity monitor.
On the servers you can use `squeue`, ganglia, or builtin commands like `htop`, `top`.
Here `top` shows me that I'm basically the only one running anything.

```{bash}
$ top
# top - 10:11:09 up 143 days, 22:18,  0 users,  load average: 0.03, 0.05, 0.05
# Tasks: 399 total,   1 running, 397 sleeping,   1 stopped,   0 zombie
# %Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
# KiB Mem:  65958464 total, 44326720 used, 21631744 free,   415068 buffers
# KiB Swap: 67089404 total,    27532 used, 67061872 free. 42760280 cached Mem
# 
#   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
#  3547 clarkf    20   0   23924   1920   1168 R   0.7  0.0   0:00.07 top
#  1428 root      39  19       0      0      0 S   0.3  0.0 810:04.09 kipmi0
```


`stdin` lets us combine arbitrary programs to great effect.
Here's an example where we mix bash, R, and Python in a single pipeline.

```{bash}
cd ~/projects/sta141c-winter19/examples/

DATAFILE="/scratch/transaction.zip"
ONLY_COLUMNS=amt_agency.csv
FIRST_DIGIT=first_digits.csv
AGENCY=18
AMT=8

unzip -p ${DATAFILE}  |
    cut -d , -f ${AGENCY},${AMT} |
    grep . |
    python3 first_char_last_column.py |
    Rscript first_char_last_column.R > test.txt
```

term: __bottleneck__ the slowest part of a program

principle: The way to accelerate your program is to remove the bottlenecks.
We identify bottlenecks by running realistic workloads and watching performance.


I would like to know which of these is the bottleneck.
If they're all using 1 CPU then the bottleneck should be using close to 100% of a CPU on `top`.
If all of the CPU usages are small, and the total CPU usage is less than that available (5 full CPUs) in this case, then IO could be the bottleneck.

By default `top` sorts by which is using the most memory.

```{bash}
$ top
#   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
#  3619 clarkf    20   0  116424  49636   3844 R  89.8  0.1   0:27.45 R
#  3615 clarkf    20   0    9128   1804    708 S  17.6  0.0   0:03.37 unzip
#  3616 clarkf    20   0    5940    608    524 S  15.2  0.0   0:02.95 cut
#  3618 clarkf    20   0   28308   6008   2656 S  11.9  0.0   0:02.27 python3
#  3617 clarkf    20   0   10472    888    772 S   1.3  0.0   0:00.28 grep
```

R is using about 90% of 1 CPU, so it's the bottleneck.

Memory usage is negligible for all steps in the pipeline, which is ideal.

Question: When will memory usage be large?
When we do something that requires a bunch of data in memory at one time, for example sorting.
That's another reason to filter before sorting.

We could fix it by profiling the R script, which we will cover in a later lecture.

Every time we remove a bottleneck something else will become the bottleneck.
`unzip` is the next largest, so we should look out for that.
Let's remove the R step and try running the pipeline.

```{bash}
unzip -p ${DATAFILE} \
    | cut -d , -f ${AGENCY},${AMT} \
    | grep . \
    | python3 first_char_last_column.py \
    > test.txt

top
#   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
#  3727 clarkf    20   0    9128   1804    708 R  93.3  0.0   0:09.58 unzip
#  3728 clarkf    20   0    5940    608    524 R  84.7  0.0   0:08.59 cut
#  3730 clarkf    20   0   28312   6012   2656 S  67.2  0.0   0:06.81 python3
#  3729 clarkf    20   0   10472    888    772 S   8.9  0.0   0:00.80 grep
#  3731 clarkf    20   0   23924   1928   1168 R   1.0  0.0   0:00.06 top
```

`unzip` is using 93% cpu, so it's the bottleneck.
It's not too bad though, because `cut` takes close to the same amount of time.

I've also unzipped the file to `/scratch/transaction.csv`, so we can check if it's faster to process this one.

```{bash}
DATAFILE="/scratch/transaction.csv"

cut -d , -f ${AGENCY},${AMT} ${DATAFILE} \
    | grep . \
    | python3 first_char_last_column.py \
    > test.txt

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 4319 clarkf    20   0    5940    612    524 R  87.4  0.0   0:25.88 cut
 4321 clarkf    20   0   28312   6012   2656 S  69.6  0.0   0:20.67 python3
 4320 clarkf    20   0   10472    888    772 S   9.6  0.0   0:02.04 grep
```

It's not really any faster, `cut` is still running at 87%.
However, it will help us use less CPU if we are only using 2 cores.

If the program is IO bound then it can paradoxically be __slower__ if we unzip it first.
That's why you have to measure and see.
