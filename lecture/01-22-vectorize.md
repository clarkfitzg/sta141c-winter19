topics: 

- pictures of replicate, lapply (sapply), tapply, apply, Map, mapply, rapply
- What the load balancing cluster apply does with chunking.
- data types
- object sizes in memory
- triple store sparse matrix
- Matrix package, S4 classes, slots
- Efficient matrix algebra
- Column oriented / row oriented
- agglomerative clustering

Questions:

> Do we have to comment code?

Only where necessary, or where confusing

```{r}
# Bad:
# get the first element of x
x[1]

# Better:
# The first element of x is the name
f(x[1])

# Best:
# Write code that doesn't need comments
f(x["name"])
```

> The workers can't find the script / files.

Then don't change the working directory (`setwd`), or relative file paths won't work.
Alternatively, you can use absolute paths, such as
`/Users/clark/projects/sta141c-winter19/lecture/outlines/01-22-vectorize.md`.

> Will the pipe make the code faster?

Nope.
It just changes the style.

Example pipe usage:

```{r}
library(magrittr) # or dplyr
result <- x %>%
    f1 %>%
    f2 %>%
    f3
```

Why is this good?

- easy to read

Without pipes:

```{r}
result = f3(f2(f1(x)))
```

With intermediate data:

```{r}
tmp1 = f1(x)
tmp2 = f2(tmp1)
result = f3(tmp2)
```

When is this good?
- if you need to actually use temporary variables
- If they're small and in functions, since they'll be garbage collected same as with the pipe
- easier debugging


> Suggestion: Maybe we can start with smaller data?
> HW takes too long to do / run.



## Review

Last class we learned a simple model for parallelism.
One manager gives commands to multiple workers and waits for the results in real time.
Nobody shares anything- the manager has to explicitly transfer data.
We have to explicitly synchronize all the state.
This is in some sense the 'simplest' possible arrangement.
Simple does not mean bad, it's practical and useful.


## Vectorization

Use `microbenchmark` for small timing experiments.

Vectorized functions operate on entire vectors at once.

```{r}
library(microbenchmark)

n = 1e4
x = rnorm(n)

# Fast- Vectorized
microbenchmark(y <- exp(x))

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
# We prefer the apply version not because it's faster, but because it's cleaner and easier to parallelize.
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

- Prefer vectorization
  String functions such as `tolower, gsub`, etc. are all vectorized.
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
```

Characters and factors are a little different.

```{r}
typeof("words and more words")

f = as.factor(c("female", "male", "female"))

typeof(f)

f
```

So factors are actually stored as integers.
How does R know what value to print?

It has an internal lookup table matching the integers to character strings.
Here's the table:

```{r}
levels(f)
```


