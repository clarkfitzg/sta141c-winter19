- What the load balancing cluster apply does with chunking.
- reasoning about object sizes in memory
- triple store sparse matrix
- Matrix package, S4 classes, slots
- Efficient matrix algebra
- Column oriented / row oriented
- agglomerative clustering



## Good questions

Help everyone else help you.
Use text, not screenshots, so that those answering can copy and paste.

#### Impossible to answer

> 2.3 I don't have the computer like that able to process all the data

#### Hard to answer

> When I run my parLapply() function, I meet this error. Can anyone help me? 

```
Error in checkForRemoteErrors(val):
    2 nodes produced errors; first error: subscript out of bounds
```

This is hard to answer because we don't know what code is causing it.
The subscript out of bounds could happen anywhere.


#### Easy to answer

> Hello,
> When I try to

```{r}
clusterCall(cls, source, "preprocess.R")
```
> It has following error:

```{r}
Error in checkForRemoteErrors(lapply(cl, recvResult)) : 
 2 nodes produced errors; first error: cannot open the connection
```

It's one line of code from the lecture notes, which makes it easy for me to reproduce, assuming that I know what the error comes from and how to fix it.


#### Going Forward

- Small, minimally reproducible examples are good
- More detail is better
- Set `options(error = traceback)` and paste the whole trace, so that we can help better

```{r}
> options(error = traceback)
> zapsmall(c(1, 1e-12), digits = numeric())
Error in zapsmall(c(1, 1e-12), digits = numeric()) : invalid 'digits'
2: stop("invalid 'digits'")
1: zapsmall(c(1, 1e-12), digits = numeric())
```


## Review

Last lecture I forgot to mention `apply`, that operates over the margins of a matrix, or array more generally.


## Object sizes in memory

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

object.size(x) - expected_size 
```

No, the actual object size is _slightly_ larger.
Why?
Because R has some memory overhead per object, a few bytes of metadata hanging out for every object.

This overhead is acceptable if it's small relative to the size of the data.
Consider a couple cases:
- Millions of objects
- Millions of data elements inside one object

The latter is far more efficient, both in storage and computation.

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

Lesson:
Using efficient data structures results in small objects and fast code.
This is critical for big data and high performance computing.


## Matrix

Statisticians, scientists, engineers, everyone loves matrices.
There are all kinds of special ones.
By using data structures that account for special structure in our data, we can increase speed and reduce memory usage.

For the next homework we will play around with sparse matrices.
Sparse matrices mean that most entries are zero.

I'll demonstrate the robust, recommended Matrix package.

This is also a good time to learn about object oriented programming.

Question: From your math classes, what kind of matrices do you know that have special structure?
- symmetric
- diagonal
- banded
- orthogonal

In object oriented programming we map these concepts to __classes__.
We write __methods__ to operate on these classes.
Object oriented programming is about organization and extensibility.

R has _several_ object oriented systems.
S3 is the basic one.
This is how functions like `plot`, `summary` work.

All the `plot` function actually does is dispatch to a method:
```{r}
> plot
function (x, y, ...)
UseMethod("plot")
<bytecode: 0x2c790a8>
<environment: namespace:graphics>
```

The Matrix package uses the S4 system.
The S4 machinery lives in the `methods` package, so we should load that up.
Extending R has a good [practical introduction to using S4](https://adv-r.hadley.nz/s4.html).
To really learn about S4, read the extensive documentation, and see John Chamber's 2016 book, "Extending R".

The [Matrix manual](https://cran.r-project.org/web/packages/Matrix/Matrix.pdf) itself is substantial- 200+ pages. 
Explain a little bit what each part does:
- Class name
- Slots
- Extends
- Methods
- See Also
- Examples

```{r}
library(methods)

library(Matrix)

m = Matrix(1:9, nrow = 3)

class(m)
```

So what's a dgeMatrix?
We need to look up the help page for the class.

```{r}
class?dgeMatrix
```

The help page says that this is a general class for dense matrices and lists many methods that are defined for this class.

We can look at the structure of this class:
```{r}
str(m)
```

This shows the underlying components, called __slots__, that together comprise an object of that class.
We can peer into the implementation and access the slots using the `@` operator.

```{r}
m@x
m@Dim

class(m@x)
class(m@Dim)
```

This shows how the data is actually stored as a one dimensional numeric vector.
The `Dim` slot allows it to behave as a 2 dimensional object.


There are three ways to create objects of some class:

1. Use a function that returns the object we want.
    That's what we did with `Matrix(1:9, nrow = 3)`
2. Coerce objects to and from different classes.
    The general way to do this is with the `as` function.
3. Directly construct objects using `new`. 

```{r}
new("dgeMatrix", x = rnorm(9), Dim = c(3L, 3L))
```

```{r}
# Convert Into a base R matrix
as(m, "matrix")

```

Question: Will a diagonal matrix be smaller than a dense general matrix?
Hopefully, it only has to store n entries.

```{r}
n = 1000
x = Matrix(rnorm(n * n), nrow = n)

# More practice: How large should the data in here be?
n * n * bytes_per_double

# We're off by ~1KB because of the overhead of having objects in R.
object.size(x)
```

Let's construct a diagonal matrix from this.

Question: Can we use `as`?
It's ambiguous to convert a dense matrix to a diagonal matrix, because we're throwing away everything that's not on the diagonal.

```{r}
# fails
d = as(x, "ddiMatrix")

# Works, we're being explicit about what we want.
d = Diagonal(x = diag(x))
```

Conversely, it's not ambiguous to convert a diagonal matrix into a dense matrix, because there is no loss of information.

```{r}
ddense = as(d, "dgeMatrix")
```

How large should the diagonal matrix be?

```{r}
# Data should be
n * bytes_per_double

# But there's some overhead
object.size(d)
```
