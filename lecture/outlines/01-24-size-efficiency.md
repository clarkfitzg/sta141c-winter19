## Review

Last lecture I forgot to mention `apply`, that operates over the margins of a matrix, or array more generally.


## Object sizes in memory

How do we calculate how large a matrix / array is?

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

Lesson:
Using efficient data structures results in small objects and fast code.

Which is more efficient?
- Millions of objects   :(
- Millions of data elements inside one object :)

The latter is far more efficient, both in storage and computation.


## Matrix

Everyone loves matrices.
Seriously, they're a huge topic in computing.

Matrix package, object oriented programming

Question: From your math classes, what kind of matrices do you know that have special structure?

Classes:
- symmetric
- diagonal
- banded
- orthogonal

Question: What kind of methods should we write for matrices?

Methods:
- `+, -, %*%`
- decompositions

Object oriented programming is about organization and extensibility.

R has _several_ object oriented systems.
S3 is the basic one, plot, summary

```{r}
> plot
function (x, y, ...)
UseMethod("plot")
<bytecode: 0x2c790a8>
<environment: namespace:graphics>
```

The Matrix package uses the S4 system.
Many good references

The [Matrix manual](https://cran.r-project.org/web/packages/Matrix/Matrix.pdf) itself is substantial- 200+ pages. 
Explain a little bit what each part does:
- Class name
- Slots
- Extends
- Methods
- See Also
- Examples

The S4 machinery lives in the `methods` package, so we should load that up.

```{r}
library(methods)

library(Matrix)

m = Matrix(1:9, nrow = 3)

class(m)
```

So what's a dgeMatrix?

```{r}
class?dgeMatrix
```

A general class for dense matrices and lists many methods that are defined for this class.

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

There are three ways to create objects of some class:

```{r}
m = Matrix(1:9, nrow = 3)

as(m, "matrix")

new("dgeMatrix", x = rnorm(9), Dim = c(3L, 3L))
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
It's a little ambiguous.

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

Are diagonal matrices closed under matrix multiplication?
Yes.

```{r}
d2 = d %*% d
class(d2)
```

Do you think diagonal matrices are faster than dense matrices?

```{r}
library(microbenchmark)

microbenchmark(x %*% x, times = 10L)

microbenchmark(d %*% d, times = 10L)
```
