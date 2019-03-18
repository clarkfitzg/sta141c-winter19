## Announcements

- If I teach this again I might use [AWS Educate](https://aws.amazon.com/education/awseducate/) as well as our campus compute servers.
    Check it out, you get $100 to play on Amazon's cloud. 
    The things you've been learning about data processing, remote servers, batch job submission all still apply in the cloud.


## Questions


## Review

Last class we saw Hadoop, Map Reduce, and Hive.

What does Hadoop give us?

- Distributed file system
- Fault tolerance
- Map Reduce / Distributed Sort

## Compiled Languages

Why use a compiled language?

- __Speed__
- Safety (more robust because they catch errors at compile time vs. run time, can be more fault tolerant)
- Build other languages?
- Interface to existing software (Example: Tesseract image processingn library)

How do bitcoin miners work?
They can use GPU's or actual dedicated hardware.
Point: things can get as fast as you like.

Goal: Compute the L2 norm of a numeric vector.

```{r}

n = 1e7L

x = rnorm(n)

l2_norm_v = function(x){
    sqrt(sum(x * x))
}

# Between 30 to 70 ms

# hand written vectorized
tv = system.time(rv <- l2_norm_v(x))["elapsed"]

# builtin norm
tn = system.time(rn <- norm(x, "2"))["elapsed"]

# How much longer?
tn / tv

library(dotCall)

# 10 ms
tc = system.time(rc <- l2norm(x))["elapsed"]

all.equal(rv, rn, rc)

```

To write C code directly from R use Rcpp package.
Or 'inline'.

## Julia

```{julia}

n = 10^7

x = randn(n)

function l2norm(x)
    out = 0.0
    for xi in x
        out += xi * xi
    end
    return sqrt(out)
end


l2norm(x)

# 11 ms
@time l2norm(x)

```

This is awesome!
Consider RJulia if you just need some fast numerical algorithm.


## Python
