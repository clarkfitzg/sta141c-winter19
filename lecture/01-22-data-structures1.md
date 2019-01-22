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
We have to explicitly synchronize all the state.
This is in some sense the 'simplest' possible arrangement.
Simple does not mean bad, it's practical and useful.


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

How do we calculate how large an array is?
Arrays are a generalization of matrices, so lets just think about matrices.

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

The list is 8 times bigger than the efficient matrix form.

Which one is faster?

```{r}
library(microbenchmark)
sum(x)
microbenchmark(sum(x))
microbenchmark(do.call(sum, xl))
```

Yes, we go from around 400 microseconds to 40 milliseconds, which means that the array form is 2 orders of magnitude faster.

For efficiency we like small objects, and fast code.

```{r}
object.size(1:1e10)
```

## Matrix

Statisticians, scientists, engineers, everyone loves matrices.
There are all kinds of special ones.
By using data structures that account for special structure in our data, we can increase speed and reduce memory usage.

For the next homework I will ask you to play around with sparse matrices.
Sparse matrices mean that most entries are zero.

I'll demonstrate the robust, recommended Matrix package.

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

The help page says that this is a general class of dense matrix and lists many methods that are defined for this class.
