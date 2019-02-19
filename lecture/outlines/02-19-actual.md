## Announcements

- HW: Nice job on this [Piazza thread](https://piazza.com/class/jqmje0ujwrm2wx?cid=234) figuring out how to sort on a specific column with `sort --key=1,1`.
  That makes me happy.
- HW: 52 assignment submissions and 44 job logs, what could have happened?

Problem: didn't use `sbatch` or `srun`.
Solution: Use `sbatch` on the cluster. 

- Who still needs partners for the project?

## Resources

- Nick and I did a [short course on Python](https://github.com/nick-ulle/2015-python) in 2015, there are more old links to learning resources there.

## Questions

> What does it mean, "no space to write?" when using `sort`?

Not enough space (hard drive) in disk spillover for sorting.

> I can't the git folder that I cloned?

You can, just use `rm -rf`

> The command for updating files on Git?

`git pull`

> Where to host the code for the project?

Anywhere is fine, it can be public.

> How many questions for the proposal?

One broad one is sufficient, or several specific ones.

Could use Github classroom for logs and submissions.

> How big should be the project be?

As big as you like :)
You can do exploratory type questions, or prediction, statistical inference, ML, visualization.
More guidance to follow.
Use any technology you want.


## Review

Shared memory parallelism

```{r}
library(parallel)

cls = makeCluster(2L, type = "FORK")

clusterEvalQ(cls, Sys.getpid())

```

Problem: Kill does not accept `stdin`
Solution: Use `xargs`

```{bash}
$ pgrep -P 16942 | xargs kill
```

# Python

What is Python used for?

- Everything! general purpose software dev
- System administration
- Data Analysis / Machine Learning / AI
- Web scraping (141B)

Why do we like Python?

- Nice syntax
- Packages, standard library "batteries included"
- Productivity
- Popular - available everywhere, cross platform

## Differences between R and Python

We can understand these historically

R: data analysis -> more general things (interactivity)
Python: general purpose -> data analysis

Similarities:

- Both are high level, dynamic, scripting languages
- Both have reference implementations in C.
- Both can be used as 'glue' languages
  Meaning: wraps a bunch of compiled code.
- Both can do general data analysis, Python + (Numpy, scipy, pandas, ...) is pretty close to R.
- Both can be object oriented languages

Differences:

- R is 1 indexed, Python 0 indexed
- R is vectorized (like Numpy)
- Python more popular than R for machine learning and AI. (tensorflow, pytorch, ...)
- Python can sometimes be faster. (really depends on what you're doing) And both are pretty slow.
- R has more statistics software
- Missing data handling is well supported in R through `NA`


low level concepts: (ECS 50 or 150)
    - opening sockets and writing bytes
    - copying memory directly
    - directly calling operating systems calls

Last July, Guido Von Rossum, quit his role as the benevolent dictator for life (BDFL).

"X is better than Y" for any technologies X and Y, this is rarely true.
Language wars are boring.

Learn multiple languages it will help your understanding.

An example: People say "R is bad because" partial argument matching

```{r}

x = rnorm(1, mean = 10)

x = rnorm(1, m = 10)
```

```{python}
import random

random.normalvariate(mu = 10, sigma = 1)

random.normalvariate(mu = 10, sig = 1)

import this

```

Python's design philosophy.

What are some other examples of things in R that are good for interactive use? But might not be in Python?

- Have to import libraries in Python
- Formula syntax in R, and non standard evaluation.


## Reference semantics

__reference__ means multiple variables refer to the same object.

```{python}
x = [10, 20, 30]

y = x

y[1] = 200

x

# Is this a deep or shallow copy?
x2 = x.copy()

x2[1] = "hello"


import copy

y2 = copy.deepcopy(x)

```

__list__ ordered collection of objects

```{python}

# Jared
l = [10, 20]

type(l)

l[1]

l[1] = 200

l.append(500)

```

__tuple__ immutable ordered collection of objects

```{python}

# Zack
t = (10, 20)

type(t)

t[1]

t[1] = 200

```

Dictionary:
Unordered collection of key-value pairs

```{python}

d = {"a": 10, "b": 20}

# Looking up
d["a"]

# Modify
d["b"] = 200

d["b"]

d[0]

```

