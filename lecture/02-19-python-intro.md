## Announcements

- HW: Nice job on this [Piazza thread](https://piazza.com/class/jqmje0ujwrm2wx?cid=234) figuring out how to sort on a specific column with `sort --key=1,1`.
  That makes me happy.
- HW: 52 assignment submissions and 44 job logs, what could have happened?
- Who still needs partners for the project?


## Resources

- Nick and I did a [short course on Python](https://github.com/nick-ulle/2015-python) in 2015, there are more old links to learning resources there.
- [Software Carpentry Lesson](https://swcarpentry.github.io/python-novice-inflammation/)
- [Python's new governance model](https://lwn.net/Articles/775105/)

## Definitions

- Python's __dot operator__ looks up named attributes.
- __Reference__ here means that multiple variables refer to the same object.
- __list__ ordered collection of objects
- __tuple__ immutable ordered collection of objects
- __dictionary__ unordered collection of key-value pairs.
- __generator__ a memory efficient iterating function


### Review

In the previous lecture we learned about shared memory parallelism.
Here's how to set up a local cluster of shared memory workers in R.

```{r}
library(parallel)
cls = makeCluster(2L, type = "FORK")

Sys.getpid()
```

The command line and pipes are useful for more than just processing data.
We can also use it to control the computer.
For example, to kill the children processes from the command line:

```{bash}
$ pgrep -P 8261 | xargs kill
```

Here's what's going on in this command:

- `pgrep -P 8261` prints the processes that are children of process 8261 to `stdout`.
- `kill 1234` will terminate process 1234. The `kill` command accepts process id's as arguments, but it cannot read them from `stdin`.
- `xargs` takes `stdin` and makes it appear as an argument that we explicitly passed.

`xargs` is another example of the flexibility and utility of the UNIX philosophy.



# Python

What is it used for?

- Everything :)
- Scientific computing
- System administration


Why do we like it?

- Friendly syntax
- Available pretty much everywhere.
  Like bash, you can assume it will be there on a Linux system.
- High level, productive
- Data scientists like it for string processing 
- standard library - Python's philosophy is 'batteries included'.

Differences / similarities between R and Python?

A good way to understand this is in a historical context.
Python was designed as a general purpose language first.
Data analysis is one of many things you can do with Python.
R came from the S language, and the focus was always data analysis, with an emphasis on interactivitiy.
People have been using R for more and more general things.

Similarities
- Both are high level, interpreted languages with reference implementations in C.
- Both 'glue' languages, meaning they can wrap lower level compiled code.
- Python with the scientific Python stack, (Numpy, pandas, scipy, etc) has a large overlap with R.

Differences
- R has richer libraries for statistics, while Python has richer libraries for machine learning at scale
- Python has richer data structures- dicts, sets, heaps, dequeues
- Missing data handling through `NA` is baked into R.

News- Python was in the news last July.
Question: What happened?
Inventor and Benevolent dictator for life, Guido Von Rossum, retired.

> The straw that broke the camel’s back was a very contentious Python enhancement proposal, where after I had accepted it, people went to social media like Twitter and said things that really hurt me personally. And some of the people who said hurtful things were actually core Python developers, so I felt that I didn’t quite have the trust of the Python core developer team anymore.

Source: [Guido Von Rossum Interview](https://www.infoworld.com/article/3292936/python/guido-van-rossum-resigns-whats-next-for-python.html?upd=1550601743301)


## Interactive

You're welcome to follow along with me as I type here.
I'm using Ipython in the terminal with Python 3.
Ipython is nice for interactive work, it includes several bash commands.
I recommend the Anaconda distribution if you want the whole scientific stack.

Language wars :(
The blanket statement 'X is better than Y' is loaded with ignorance and arrogance.

People criticize R when it doesn't behave like Python.
For example, R will partially match argument names, while Python will throw an error.

R:
```{r}
# Full matching
rnorm(1, m = 10)

# Partial matching works
rnorm(1, m = 10)
```

Python:
```{python}
import random

# Full matching
random.normalvariate(mu = 10, sigma = 1)

# Partial matching fails
random.normalvariate(m = 10, sigma = 1)
```

This behavior can be understood with the historical context.
R's partial argument matching can be helpful for interactive use.

Python and R are both just being true to their respective design philosophy.

```{python}
import this
```

> In the face of ambiguity, refuse the temptation to guess.

Question: For those that know both languages, can you think of any other features that are better for interactive use, and less so for software engineering?
Global variables vs. namespaces and non standard evaluation come to mind.


## Reference semantics

Python has objects with reference semantics.
In contrast, R's usual model is copy on write.

```{python}
x = [10, 20, 30]
y = x
y[1] = 100
x
```

`x` includes 100 now, because `x` and `y` refer to the same object.
If we actually want to copy `x` we need to be very explicit about it.

```{python}
import copy
y = copy.deepcopy(x)
y[1] = 200
x
```

This is different from a shallow copy.


## Examining objects:

In Ipython, we can write the object name, followed by dot `.` and press tab to see the public methods.

```{python}
x.
```

To see all the methods and attributes we can call `dir()`.

```{python}
dir(x)
```

What are some other helpful functions?

- `type`
- `len`


## Data structures:

- Slicing
- len
- `__builtin__` and import
- immutability


Common data structures:
- tuples, lists, dicts, generators

### list

A list in Python is just like a list in R, but it doesn't have names.

```{python}
l = [10, 20, 30]

type(l)

# Index lookup
l[0]

# Modify
l[0] = 100

# Modify
l.append(40)

len(l)
```


### tuple

Tuples are similar to lists, but they are immutable, which means they can't be modified.

```{python}
t = (10, 20, 30)

type(t)

# Index lookup
t[0]

t[0] = 100
# TypeError

len(t)
```

Running `t.` from Ipython we see fewer methods compared to the list.
This is because we can only query it, and cannot modify it.


### dictionary 

A dictionary holds an unordered collection of key-value pairs.
The whole language is built around them.

```{python}
d = {"a": 10, 20: 700}

type(d)

# Key value lookup
d["a"]

# Modify
d["b"] = "hello"

# Can we extract a value with an integer index?
d[0]
# No way, KeyError
```

More generally, anything that's immutable and hashable can be a key, and anything at all can be a value.
tuples are immutable, so they can be keys, but lists cannot.

```{python}
# Works fine.
d[t] = 7

# Fails.
d[l] = 8
```


### generator

Generators, and iterators more generally, are a powerful feature of the Python language.
Unlike the other objects, they do not hold data in memory if they can help it.
They just know how to produce the next element.

```{python}
g = (2*x for x in range(4))

# Explicitly calling next
next(g)

g = (2*x for x in range(4))

for x in g:
    print(x)
```

Question: Where have we seen this concept before?
Piped commands in bash.
It's useful because it allows us to operate on potentially infinite data streams.


### Iterating through a CSV file



Later Topics:

- EAFP (Easier to Ask Forgiveness than Permission)
- Functions and docstrings.
