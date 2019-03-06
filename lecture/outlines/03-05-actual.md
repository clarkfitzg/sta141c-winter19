Announcements:

- Nice job!
  This class in general, and HW5 in particular, was challenging for many.
  I'm proud of the effort you put in.
- Now you should be focusing on the final project
- I'll post the peer review assignment this week, it shouldn't take much time.
- data repository - one possible output of your project is a refined data file.
    For example, [dash at UC Davis](https://dash.ucop.edu/stash)


## Questions

Remember to back up your data!!
Hard drive failure is real.



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


```{r}

# KL divergence between two discrete probability distributions
kld = function(p, q)
{
    tmp = p * log(p / q)
    sum(tmp, na.rm = TRUE)
}

p1 = c(0.36, 0.48, 0.16)
p2 = c(0, 0.5, 0.5)
q1 = rep(1/3, 3)

# Check if they are 'close enough'
tol = 1e-3
all.equal(1.0, 0.9999, tolerance = tol)


# For quick and dirty we can use stopifnot
stopifnot(
all.equal(kld(p1, q1), 0.0852996, tolerance = tol),
0 < kld(p2, q1)
)


# Writing the test

# Other testing packages:
# testthat, RUnit
```

The order of writing things:
1. documentation for function
2. failing unit test 
3. add just enough code to pass the unit test


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

Use `Rprof` to profile.

```{r}
small_set = 2:6

# Turn the profiler on:
Rprof()

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

What does the function actually do?
Lets go in and see.

```{r}

debugonce(bootstrap)

bootstrap(digits_count_list_by_id[[2]])

```

Hypothesis: if each element were a vector, then KLD calculation might be fast.

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

Rprof()
t2 = system.time({
bootstrap_result = lapply(digits_count_list_by_id[small_set], function(x){
  res <- replicate(1000, bootstrap2(x))
  res
})
})
Rprof(NULL)

# Original time
t1

# Better :)
t2


# But there are warnings!
# Comes from missing digits, so we can convert it to a factor to account for this.

# Almost always bad
(1:10) / (1:3)

# Solution: use a factor

x = sample(1:2, size = 10, replace = TRUE)

y = sample(factor(1:3), size = 10, replace = TRUE, prob = c(0.499, 0.499, 0.002))

table(y)


#@param: element : a table with 9 columnds showing the count of each digits of each agency id
bootstrap3 = function(element) {
  element = t(element)
  colnames(element) = c('count')
  sample_size = sum(element)
  sample_space = rep(as.factor(seq(1,9)), element[,'count'])
  each_sample = sample(sample_space, sample_size, replace = TRUE)
  prop_table_each_sample = prop.table(table(each_sample))
  prop_table_each_sample = as.numeric(prop_table_each_sample)
  kld2(prop_table_each_sample)
}

Rprof()
t3 = system.time({
bootstrap_result = lapply(digits_count_list_by_id[small_set], function(x){
  res <- replicate(1000, bootstrap3(x))
  res
})
})
Rprof(NULL)

t1
t2
t3


```

