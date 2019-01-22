Announcements:

- My office hours Thursday will be in the Data Science Initiatve, Shields 360, right after class.

## Notes on first HW

- Grades for HW1 are available.
  Ask Siteng in OH if you have questions / clarifications.
- Difference between formatting numbers for humans and for machines.
  What's this number? 3414992319 is 3.4 billion
  Communication- a report is for communicating with humans.
  So put them on a table in units that make it easy for humans to read.
- Submit homework in a format that Canvas can preview- pdf, html, docx.
  We're using the online system to grade- make it easy on the graders.

Questions:

Do we have to comment code?

Only where necessary, or where confusing

# Bad:
# get the first element of x
x[1]

# Better:
# The first element of x is the name
f(x[1])

# Best:
# Write code that doesn't need comments
f(x["name"])

What is an absolute path?

DATADIR = "~/data/awards"

# Don't change the working directory, or relative file paths won't work.

/Users/clark/projects/sta141c-winter19/lecture/outlines/01-22-vectorize.md

Will the pipe make the code faster?

library(magrittr) # or dplyr
x %>% f
vs 
f(x)

# When is this good?
# - easy to read
result <- x %>%
    f1 %>%
    f2 %>%
    f3

result = f3(f2(f1(x)))

# When is this good?
# - if you need to actually use it!
# - If they're small and in functions
# - debugging!
tmp1 = f1(x)
tmp2 = f2(tmp1)
result = f3(tmp2)

# Suggestion: Maybe we can start with smaller data?
Takes too long to run.

# Homework due Wednesday
# Office hours after class today- Shields library room 360 DSI

on board

- review independent workers model for parallelism
- pictures of replicate, lapply (sapply), tapply, apply, Map, mapply, rapply
- What the load balancing cluster apply does with chunking.

 

## Vectorization

Use `microbenchmark` for small timing experiments.

Vectorized functions operate on entire vectors at once.

```{r}
library(microbenchmark)

n = 1e4
x = rnorm(n)

# Fast- Vectorized
microbenchmark(y <- exp(x))

# This is not how exp is designed to be used.
exp_apply = function(x) sapply(x, exp)

# Slow
microbenchmark(y_apply <- exp_apply(x))

exp_loop_preallocated = function(x)
{
    # Preallocation means we create a place for the answers to go.
    result = numeric(length(x))
    for(i in seq_along(x)){
        result[i] = exp(x[i])
    }
    result
}

# Turn off the byte code compiler
enableJIT(0)

# Slow
microbenchmark(y_loop_preallocated <- exp_loop_preallocated(y), times = 10L)


exp_loop_growing = function(x)
{
    # Dynamically grow the result by appending to the end.
    result = c()
    for(i in seq_along(x)){
        result = c(result, exp(x[i]))
    }
    result
}

# Disaster
microbenchmark(y_loop_growing <- exp_loop_growing(y), times = 10L)

```

Moral of the story?

- Prefer vectorization whenever possible.
  String functions such as `tolower, gsub`, etc. are all vectorized.
- Apply functions are clean, easier to parallelize, and they always preallocate correctly.
- Avoid dynamically growing objects



## Data types

The goal today is to learn a little about how to reason about how large something is.
Number crunching is fast because of contiguous blocks of homogeneously typed memory.

Question: What are the possible low level types for R in memory?
- 

```{r}
typeof(TRUE)
typeof(1L)
typeof(1)
typeof(1+0i)
typeof(raw(10L))
```

Characters and factors are a little different.

```{r}
typeof("words and more words")

f = as.factor(c("female", "male", "female"))

typeof(f)

f
```

Factors are actually stored as integers.
How does R know what value to print?

It has an internal lookup table matching the integers to character strings.

```{r}
levels(f)
```

How do we calculate how large an array is?

```{r}
n = 1000
p = 500
x = matrix(rnorm(n * p), nrow = n)

typeof(x)

# Expert knowledge!
bytes_per_double = 8

expected_size = n * p * bytes_per_double
```

Is the object the expected size?

```{r}
object.size(x)
```

Not exactly.
Question: Why not?
Because R has some memory overhead per object, a few bytes of metadata hanging out for every object.

Question: How large will it be if we store this in a general container, like a list?

```{r}
xl = lapply(x, identity)
object.size(xl)

as.numeric(object.size(xl) / object.size(x))
```

The list is 8 times bigger than the efficient matrix form. :(

Which one is faster?

```{r}
library(microbenchmark)
sum(x)
microbenchmark(sum(x))
microbenchmark(do.call(sum, xl))
```

The matrix is 2 orders of magnitude faster.

For efficiency we like small objects, and fast code.


## Matrix

Use the right data structure to increase speed and reduce memory usage.

```{r}
library(Matrix)

m = Matrix(1:10, nrow = 2)

class(m)
```

So what's a dgeMatrix?
We need to look up the help page for the class.

```{r}
?dgeMatrix # Nope

class?dgeMatrix
```
