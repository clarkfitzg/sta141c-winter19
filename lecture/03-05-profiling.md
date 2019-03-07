Announcements:

- Nice job!
  This class in general, and HW5 in particular, was challenging for many.
  I'm proud of the effort you put in.
- Now you should be focusing on the final project
- I'll post the peer review assignment this week, it shouldn't take much time.
- data repository - one possible output of your project is a refined data file.
    For example, [dash at UC Davis](https://dash.ucop.edu/stash)

Terms:

- __Profiling__ Measuring a program to see where it is slow

Links:

- [Script: Streaming between databases](
- [Advanced R profiling chapter](http://adv-r.had.co.nz/Profiling.html)
- [Wikipedia: test driven development](https://en.wikipedia.org/wiki/Test-driven_development)


## Review

Last time we learned about performance monitoring.
If we're piping together several commands using pipes, then the __bottleneck__ is the process that is slowest, taking up close to 100% of 1 CPU.
The way to accelerate your program is to remove or accelerate the bottlenecks.

Do not assume you know what is making your code slow.
Run the code and measure it directly.

One way to profile a python script `foo.py` is to run the script with the `cProfile` module:

```{bash}
python3 -m cProfile foo.py
```


## Test driven development

Test driven development is a software development methodology.
The idea:

1. Write a failing test
2. Write code until it passes

As we discussed in a previous lecture, this helps us to focus.

On Piazza I saw many questions on calculating the KLD.
There are some packages that will do it, but for this assignment I think it was easier just to write the formula out.

Here's how to use test driven development.

Start with an empty function and a failing test.

```{r}
# Calculate KL divergence between two discrete probability distributions
kld = function(p, q)
{
    tmp = p * log(p / q)
    #sum(tmp)
    sum(tmp, na.rm = TRUE)
}

# Duplicate example from wikipedia
# https://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence#Basic_example
p1 = c(0.36, 0.48, 0.16)
p2 = c(0, 0, 1)
q1 = rep(1/3, 3)

# We'll check that the numbers are the same up to some tolerance tol
tol = 1e-3

# Should be TRUE
all.equal(0.99999, 1.0, tolerance = tol)

stopifnot(
all.equal(kld(p1, q1), 0.0852996, tolerance = tol)
, all.equal(kld(q1, p1), 0.097455, tolerance = tol)
, 0 < kld(p2, q1)
)

```

`stopifnot` is a quick and dirty way to write a test.
If you're developing a package, or testing more seriously then you will want to look into frameworks like 'testthat' and 'RUnit'.



## Profiling

Here's some code that a student wrote, and we would like to make it faster.

Setup:

```{r}
library(data.table)
library(plyr)

setwd("~/scratch/rprof_demo/rprof_demo/")

digits_count_table_by_id = fread("digits_count_table_by_id.csv", header = TRUE)
colnames(digits_count_table_by_id)[1] = 'id'

temp = dlply(digits_count_table_by_id, .(id))
digits_count_list_by_id = lapply(temp, function(x) {x['id'] = NULL; x})

actual_distribution_table = fread("q_table.csv", header = TRUE)
actual_distribution_table$V1 = NULL
```


Actual code:

```{r}
#@param element : a table with 9 columns showing the count of each digits of each agency id
#@param q_table : a table with 9 columns showing the count of each digits across the whole dataset
kld = function(element, q_table = actual_distribution_table) {
  sum (element * log(element / q_table), na.rm = TRUE)
}

#@param: element : a table with 9 columnds showing the count of each digits of each agency id
bootstrap = function(element) {
  element = t(element)
  colnames(element) = c('count')
  sample_size = sum(element)
  sample_space = rep(seq(1,9), element[,'count'])
  each_sample = sample(sample_space, sample_size, replace = TRUE)
  prop_table_each_sample = prop.table(table(each_sample))
  kld(prop_table_each_sample)
}
```

Now we can benchmark with `Rprof`.

This turns on the profiler inside R.
The profile looks at the call stack at regular intervals to see where the program is spending it's time.
In contrast to Python's deterministic profiler, this is random and based on sampling.

```{r}

# Turn the profiler on:
Rprof()

small_set = 2:6

t1 = system.time({
bootstrap_result = lapply(digits_count_list_by_id[small_set], function(x){
  res <- replicate(1000, bootstrap(x))
  res
})
})

# Turn the profiler off:
Rprof(NULL)

# Check the summary.
summaryRprof()
```

It takes around 12 seconds on the small sample set.

Here's the output:

```
$by.total
                           total.time total.pct self.time self.pct
"bootstrap"                     11.32    100.00      0.16     1.41
"lapply"                        11.32    100.00      0.16     1.41
"FUN"                           11.32    100.00      0.00     0.00
"replicate"                     11.32    100.00      0.00     0.00
"sapply"                        11.32    100.00      0.00     0.00
"kld"                            9.84     86.93      0.12     1.06
"Ops.data.table"                 7.84     69.26      0.04     0.35
"NextMethod"                     6.36     56.18      0.06     0.53
"Ops.data.frame"                 6.30     55.65      0.20     1.77
"data.frame"                     5.10     45.05      0.14     1.24
"as.data.frame"                  4.74     41.87      0.28     2.47
"as.data.frame.list"             4.70     41.52      0.08     0.71
"do.call"                        4.54     40.11      0.04     0.35
"<Anonymous>"                    4.52     39.93      0.34     3.00
"as.data.frame.numeric"          3.40     30.04      0.38     3.36
"paste"                          2.14     18.90      0.24     2.12
"force"                          2.14     18.90      0.02     0.18
"deparse"                        1.90     16.78      0.62     5.48
"Math.data.frame"                1.50     13.25      0.02     0.18
"%in%"                           1.42     12.54      0.26     2.30
"as.data.table.data.frame"       1.42     12.54      0.02     0.18
"as.data.table"                  1.42     12.54      0.00     0.00
"mode"                           1.16     10.25      0.22     1.94
"[<-"                            1.10      9.72      0.02     0.18
"[<-.data.table"                 1.08      9.54      0.02     0.18
```

The first lines say that 100% of the program time is spent in the `bootstrap` function.
Then we spend 87% of the time inside the `kld` function.
Most of the calls under this seem to be related to data frames.
The other essential function calls for the bootstrap `sample` and `table`, but those account appear to account for only a small amount of the total time, 7% and < 1% respectively:

```
"table"                          0.82      7.24      0.32     2.83
"sample"                         0.04      0.35      0.00     0.00
```

Let's find out what's going on in the function.

```{r}
debugonce(bootstrap)

bootstrap(digits_count_list_by_id[[2]])
```

It's a data frame.
We're spending a lot of time dealing with the data frame structure.
Can we simplify things by using a vector instead of a data frame?

I'm going to make some minimal changes to see if we can get a speedup.
Namely, I'm going to convert the relatively large and complex data frames into simple vectors.

```{r}

actual_distribution_table2 = as.numeric(actual_distribution_table)

kld2 = function(element, q_table = actual_distribution_table2) {
  sum (element * log(element / q_table), na.rm = TRUE)
}


#@param: element : a table with 9 columnds showing the count of each digits of each agency id
bootstrap2 = function(element) {
  element = t(element)
  colnames(element) = c('count')
  sample_size = sum(element)
  sample_space = rep(seq(1,9), element[,'count'])
  each_sample = sample(sample_space, sample_size, replace = TRUE)
  prop_table_each_sample = prop.table(table(each_sample))
  prop_table_each_sample = as.numeric(prop_table_each_sample)
  kld2(prop_table_each_sample)
}
```

MAKE SURE you keep a copy of the original code that is working as you start tweaking it for performance.
You can do this with version control.

Let's see if this made it any faster.


```{r}
Rprof()

t2 = system.time({
bootstrap_result = lapply(digits_count_list_by_id[small_set], function(x){
  res <- replicate(1000, bootstrap2(x))
  res
})
})

Rprof(NULL)

summaryRprof()
```

Uh oh, warnings!
Pay attention to these and fix them.

```{r}
> warnings()
Warning messages:
1: In element/q_table :
  longer object length is not a multiple of shorter object length
2: In element * log(element/q_table) :
  longer object length is not a multiple of shorter object length
```

This particular warning means that we're doing something like this:

```{r}
(1:7) / (1:2)
```

This particular warning is almost always a mistake with our code. as it is in this case.

An important lesson- we were trying to speed things up, and we did, but we broke the code in the process.

We've gone down from 12 seconds to 1.7 seconds, which is about an order of magnitude improvement, so it was worth our time.
Think of it as going from 12 hours to 1.7 hours on the cluster.

```
# Check the summary.
summaryRprof()

$by.total
                       total.time total.pct self.time self.pct
"system.time"                1.70    100.00      0.00     0.00
"FUN"                        1.56     91.76      0.02     1.18
"lapply"                     1.56     91.76      0.02     1.18
"replicate"                  1.56     91.76      0.00     0.00
"sapply"                     1.56     91.76      0.00     0.00
"bootstrap2"                 1.54     90.59      0.02     1.18
"prop.table"                 0.82     48.24      0.04     2.35
"table"                      0.78     45.88      0.12     7.06
"factor"                     0.44     25.88      0.18    10.59
"as.matrix"                  0.42     24.71      0.02     1.18
"t.data.frame"               0.42     24.71      0.00     0.00
"t"                          0.42     24.71      0.00     0.00
"as.matrix.data.frame"       0.40     23.53      0.14     8.24
"gc"                         0.14      8.24      0.14     8.24
"vapply"                     0.14      8.24      0.06     3.53
"unique"                     0.14      8.24      0.04     2.35
"levels"                     0.12      7.06      0.12     7.06
"sample.int"                 0.12      7.06      0.12     7.06
"sample"                     0.12      7.06      0.00     0.00
"unique.default"             0.10      5.88      0.10     5.88
"match.arg"                  0.10      5.88      0.04     2.35
"order"                      0.10      5.88      0.02     1.18
"kld2"                       0.08      4.71      0.02     1.18
```

Before `kld` took up 85% of the program.
Now `kld2` takes up less than 5% of the program- sweet!
This is a best case scenario.


## Warnings


Let's fix that warning.

It came when we sampled 

```{r}

```

Here's the full program now:

```{r}
#@param: element : a table with 9 columnds showing the count of each digits of each agency id
bootstrap2b = function(element) {
  element = t(element)
  colnames(element) = c('count')
  sample_size = sum(element)
  one_to_9 = factor(seq(1,9))   # <----------------- Changed
  sample_space = rep(one_to_9, element[,'count'])
  each_sample = sample(sample_space, sample_size, replace = TRUE)
  prop_table_each_sample = prop.table(table(each_sample))
  prop_table_each_sample = as.numeric(prop_table_each_sample)
  kld2(prop_table_each_sample)
}

Rprof()

t3 = system.time({
bootstrap_result = lapply(digits_count_list_by_id[small_set], function(x){
  res <- replicate(1000, bootstrap2b(x))
  res
})
})

Rprof(NULL)

t3
```


The hard limits to our optimization are `table` and `sample`.
If these are the bottlenecks then it's going to take vastly more effort to improve these.

```{r}
summaryRprof()

$by.total
                       total.time total.pct self.time self.pct
"system.time"                1.40    100.00      0.00     0.00
"lapply"                     1.26     90.00      0.02     1.43
"FUN"                        1.26     90.00      0.00     0.00
"replicate"                  1.26     90.00      0.00     0.00
"sapply"                     1.26     90.00      0.00     0.00
"bootstrap2b"                1.24     88.57      0.02     1.43
"t.data.frame"               0.44     31.43      0.00     0.00
"t"                          0.44     31.43      0.00     0.00
"as.matrix"                  0.40     28.57      0.02     1.43
"as.matrix.data.frame"       0.38     27.14      0.14    10.00
"prop.table"                 0.34     24.29      0.04     2.86
"table"                      0.30     21.43      0.08     5.71
"factor"                     0.18     12.86      0.04     2.86
"levels"                     0.16     11.43      0.12     8.57
"NextMethod"                 0.16     11.43      0.10     7.14
"gc"                         0.14     10.00      0.14    10.00
"rep.factor"                 0.12      8.57      0.00     0.00
"rep"                        0.12      8.57      0.00     0.00
"match.arg"                  0.10      7.14      0.06     4.29
"unique"                     0.10      7.14      0.06     4.29
"sample"                     0.10      7.14      0.02     1.43
```

This still says that `t` takes up 31 percent of the time.
Question: How do we further improve it?
Answer: Bring the call to `replicate` into the `bootstrap` function.
All the calculations before the call to `sample` will be exactly the same for every replication.
So they are redundant.
Doing this is an exercise for the reader.


## Other topics:

- tryCatch
- logging
- on.exit
- variable arguments ...
- lazy evaluation
- test driven development
- DB streaming example
