topics: 

- pictures of replicate, lapply (sapply), tapply, apply, Map, mapply, rapply
- What the load balancing cluster apply does with chunking.

## Notes on first HW

- Grades for HW1 are available.
  Ask Siteng if you have questions / clarifications.
- Difference between formatting numbers for humans and for machines.
  What's this number? 3414992319 is 3.4 billion
  Communication- a report is for communicating with humans.
  So put them on a table in units that make it easy for humans to read.
- Submit homework in a format that Canvas can preview- pdf, html, docx.
  We're using the online system to grade- make it easy on the graders.
  

## Review

Last class we learned a simple model for parallelism.
One manager gives commands to multiple workers and waits for the results in real time.
Nobody shares anything- the manager has to explicitly transfer data.


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
