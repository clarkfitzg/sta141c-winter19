# ## Announcements
# 
# - Scores for HW4 available
# - HW5 available, we'll have one more short peer review assignment after this.
#     You'll need to do hw5 so that you can do the peer review later.
# - It surprised me how many people used `awk` for the last homework.
#   Who actually knows `awk`?
# - Clean up after yourselves on the server.
#   You can write to your home directories, but if you write into /scratch on the worker nodes then you need to remove these files when you are done.
# 
# 
# ## Questions?
# 
# 
# ## Review
# 
# One great thing about Python is the standard library and all the built in data structures and algorithms.
# I told you about:
# 
# - __list__ ordered collection of objects
# - __tuple__ immutable ordered collection of objects
# - __dictionary__ unordered collection of key-value pairs
# 
# In 
# 
# 
# ## Iterators
# 
# Iterators allow us to represent infinite data streams.
# So cool!
# 
# Term: __iterator__ an object that can be looped over.
# 
# Another way to think of an iterator is as a function that maintains state, and always knows how to produce the next element.
# More technically they implement the [iterator protocol](https://docs.python.org/3.7/library/stdtypes.html#iterator-types).
# 
# Term: __generator__  function that behaves as an iterator
# 

# A function:
def times2(x):
    return 2 * x

times2(100)

# A generator uses yield rather than return
def doubler(x):
    for element in x:
        yield 2 * element

r = range(5)

# range is an iterator, a lazy one
r

# What kind of arguments does the generator we wrote accept?
# Anything that we can write a loop over- that is, any iterator.
rd = doubler(r)

# The most important thing with the iterator protocol is producing the next element
next(rd)

# Every time we call next, the generator picks up right where it left off in the function.
# That is, they maintain their state.
next(rd)

# Eventually we run out of elements.
# Because we're maintaining state there's no way to go backwards.

# Comprehension syntax

# We can write the generator more succintly using comprehension syntax:

# Generator comprehension
g = (2*x for x in range(5))

# List comprehension
l = [2*x for x in range(5)]

# Set comprehension
s = {2*x for x in range(5)}

# Dictionary comprehension
d = {x: 2*x for x in range(5)}
