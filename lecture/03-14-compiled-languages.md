## Announcements

- Thanks for an exciting quarter!
- Keep in touch, write me a note in a year or two and let me know what kind of cool stuff you're doing with data.
    Feel free to add me as a contact on [LinkedIn](https://www.linkedin.com/in/clarkfitzg/).
- I'll be in touch with the winning project team(s) via email after spring break.
- If I teach this again I might use [AWS Educate](https://aws.amazon.com/education/awseducate/) as well as our campus compute servers.
    Check it out, you get $100 to play on Amazon's cloud. 


## Resources

[Minimal Examples of R / C interfaces](https://github.com/clarkfitzg/templates/tree/master/R)
[Wikipedia: Compiler](https://en.wikipedia.org/wiki/Compiler)

Question: Suppose you're working in a high level language like R or Python.
Why would we take the time to rewrite part of our program in a compiled language?
Answer: Speed.
    If no fast software exists to do what we want, then we have to write it in a low level language ourselves.
This is especially true for developing new numerical algorithms.

Another reason is to interface to an existing library with C bindings.
This is a nice reason to write software in C- because then any higher level language can interface to it and use it.


## Goal

Let's compute the L2 norm of a vector in several different languages, and see how fast we can make it run.
Languages that are used for scientific computing probably have a function for this, so we can compare performance.


## R

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


Let's try using it:

```{r}

n = 1e7L
x = rnorm(n)

# Builtin

t1 = system.time(n1 <- norm(x, type = "2"))["elapsed"]

# Our hand written C, with no special optimizations
library(dotC)

t2 = system.time(n2 <- l2norm(x))["elapsed"]

t1 / t2

```

On my Mac the hand written C code is around an order of magnitude faster.
To see why, we can look in the actual code for norm:

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

```{julia}

n = 10^7
x = randn(n)

function l2norm(x)
    out = 0.0
    for xi in x
        out += xi^2
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

The Julia code takes between 0.01 and 0.02 seconds, which is comparable to the C code in R.
The differences in speed can come from which compiler optimizations are turned on.

##
