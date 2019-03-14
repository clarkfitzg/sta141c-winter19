## Announcements

- If I teach this again I might use [AWS Educate](https://aws.amazon.com/education/awseducate/) as well as our campus compute servers.
    Check it out, you get $100 to play on Amazon's cloud. 
    The things you've been learning about data processing, remote servers, batch job submission all still apply in the cloud.


## Questions


## Review

Last class we saw Hadoop, Map Reduce, and Hive.

Question: What does Hadoop give us?

- Map Reduce computational model
- distributed file system
- fault tolerance
- distributed sort



## Resources

[Minimal Examples of R / C interfaces](https://github.com/clarkfitzg/templates/tree/master/R)
[Reference: R language Extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html)
[Wikipedia: Compiler](https://en.wikipedia.org/wiki/Compiler)

A good analogy for performance improvement:
I filled up the disk on my local hard drive while doing this class.
To make more space I went through and deleted some of the largest files I had.
Tuning a program for performance is the same way- we want to eliminate the largest bottlenecks.

Question: Suppose you're working in a high level language like R or Python.
Why would we take the time to rewrite part of our program in a compiled language?
Answer: Speed.
    If no fast software exists to do what we want, then we have to write it in a low level language ourselves.
This is especially true for developing new numerical algorithms.

Another reason is to interface to an existing library with C bindings.
This is a nice reason to write software in C- because then any higher level language can interface to it and use it.
Term: __glue language__ is a high level language that connects lower level languages.

Question: How do bitcoin miners work?
Answer: Chips specialized to the actual algorithm.
I've heard it said that "you can always get another order of magnitude speedup".
You can always go down to the assembler code under C.
Or you can do like the bitcoin miners do, and design ASICS- application specific integrated circuits.


## Goal

Let's compute the L2 norm of a vector in several different languages, and see how fast we can make it run.
Languages that are used for scientific computing probably have a function for this, so we can compare performance.

Just to be clear, the compilers that are included with R and Python are byte code compilers.
They do not compile down to machine code.


## R

I'll show you one of R's C interfaces.
For R, you can also look at the Rcpp package, or Rjulia to call Julia code.
Many people find this easier to work with than R's C interfaces.

We can install an R package from source on our local machine:

```{bash}
$ # Navigate to top level package to directory, then:
$ R CMD INSTALL .
```

This triggers compilation of the code.
We'll see lines like:

```{bash}
/usr/local/opt/llvm/bin/clang -fopenmp -I"/usr/local/lib/R/include" -DNDEBUG   -I/usr/local/opt/gettext/include -I/usr/local/opt/llvm/include  -fPIC  -g -O3 -Wall -pedantic -std=gnu99 -mtune=native -pipe -c l2norm.c -o l2norm.o
```

This is producing the object code from the C source code.


Here's the C code under the `l2norm` function:

```{c}
#include <math.h>

// Dot product
void c_l2norm(double *x, int *n, double *out)
{
    *out = 0.0;
    for(int i = 0; i < *n; i++)
    {
        *out += x[i] * x[i];
    }
    *out = sqrt(*out);
}
```

Here's the R code to call this C code:

```{r}
l2norm = function(x)
{
    # Coerce args to correct types first
    x = as.numeric(x)
    n = as.integer(length(x))

    # Output is only returned by modifying arguments in place
    out = numeric(1)

    # .C returns list(out, x, n)
    .C(c_l2norm, x, n, out = out)$out
}
```

The `.C` is where we actually call the compiled code.
In R, whenever we see `.C, .Call, .Fortran, .Internal, .External` or `.Primitive`, then the R code calls lower level compiled code.

R's documentation for the `.Internal` function is pretty funny:

```
Internal                 package:base                  R Documentation

Call an Internal Function

Description:

     ‘.Internal’ performs a call to an internal code which is built in
     to the R interpreter.

     Only true R wizards should even consider using this function, and
     only R developers can add to the list of internal functions.
```

In contrast, we can also use R's C level API with the `.Call` interface.
This means we need to know both C and R's C level API.

Here's the R code:
```{r}
l2norm = function(x)
{
    out = 0.0
    .Call(c_l2norm, as.numeric(x), out)
    out
}
```

And the C code:

```{c}
#include <math.h>
#include <R.h>
#include <Rinternals.h>

// Dot product
SEXP c_l2norm(SEXP x, SEXP out)
{
    // C pointers to the actual data
    double *xp = REAL(x);
    double *outp = REAL(out);

    int n = length(x);

    for(int i = 0; i < n; i++)
    {
        *outp += xp[i] * xp[i];
    }
    
    *outp = sqrt(*outp);

    return out;
}
```


Let's try using it:

```{r}

n = 1e7L
x = rnorm(n)

# Builtin
tn = system.time(rn <- norm(x, type = "2"))["elapsed"]


# A vectorized version
l2norm_v = function(x) sqrt(sum(x * x))

tv = system.time(rv <- l2norm_v(x))["elapsed"]


# Our hand written C, with no special optimizations
library(dotCall)

tc = system.time(rc <- l2norm(x))["elapsed"]

# Do they get the same answer?
all.equal(rn, rv, rc)
# yes.

tn / tv

tn / tc

```

On my Mac the hand written C code is around 17 ms, which is an order of magnitude faster than the built in `norm`.
To see why, we can look in the actual code for `norm`:

```{r}
> norm
function (x, type = c("O", "I", "F", "M", "2"))
{
    if (identical("2", type)) {
        svd(x, nu = 0L, nv = 0L)$d[1L]
    }
    else .Internal(La_dlange(x, type))
}
<bytecode: 0x7f7fd56985d0>
<environment: namespace:base>
```

For the L2 norm it's doing something more general for matrices based on the Singular Value Decomposition (SVD).
`norm` calls `svd` which calls `La.svd` which eventually calls `.Internal`.
Every step adds several checks and handles special cases.


## Julia

Julia is based on Just In Time (JIT) compilation.
This means it compiles functions when they are called inside the user code.

```{julia}

n = 10^7
x = randn(n)

function l2norm(x)
    out = 0.0
    for xi in x
        out += xi*xi
    end
    return sqrt(out)    
end

# Call it once so that we don't record the time for the JIT compilation
l2norm(x)

# Measure how long it takes
@time l2norm(x)

# Close the Julia interpreter
exit()
```

The Julia code takes between 10 and 20 ms, which is comparable to the C code we called from R.
That's wicked fast!
The differences in speed can come from which compiler optimizations are turned on.

Julia code is easier to write than C code.
We can even call this Julia code from R.


## Python

Python 

```{python}

import numpy as np

n = 10 ** 7

x = np.random.randn(n)

def l2norm(x):
    out = 0.0
    for xi in x:
        out += xi*xi
    return np.sqrt(out)    


# Ipython measure how long it takes
%timeit l2norm(x)
```

It takes close to 2000 milliseconds in Python.

But if we use the compiler from numba:

```{python}

from numba import jit

@jit
def l2norm_jit(x):
    out = 0.0
    for xi in x:
        out += xi*xi
    return np.sqrt(out)    

# Call it once to activate the JIT:
l2norm_jit(x)

%timeit l2norm_jit(x)
```

Now it takes around 10 ms- sweet!


## Final thoughts

- Thanks for an exciting quarter!
- I've learned a lot by teaching my first class, thanks for being the first ones.
- Keep in touch, write me a note in a year or two and let me know what kind of cool stuff you're doing with data.
    Feel free to add me as a contact on [LinkedIn](https://www.linkedin.com/in/clarkfitzg/).
- I'll be in touch with the winning project team(s) via email after spring break.

Advice:

- Be curious, and keep learning.
    This is an exciting time to be in data science, and the opportunities are rich.
- To take your skills to the next level, carefully read the official documentation for the tools that you are using.
    Then read the source code to see what is actually happening.
    Then contribute to the source code :)
