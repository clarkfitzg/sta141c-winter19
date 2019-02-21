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

# Will there be solutions posted?
# Yes, we'll get one.


# ## Review

# List
l = [1, 2, 3]

for x in l:
    print(x)


# Generator

bailey = (2*x for x in range(4))

next(bailey)

# A function

def times2(x):
    return 2 * x

times2(100)


# What kind of object can x be?
# Any iterable! (provided x*element) makes sense
def doubler(x):
    for element in x:
        yield 2 * element


# A lazy iterator
r = range(5)

g = doubler(r)

list(g)

# What's the difference between data structure and object oriented?

# Comprehension syntax

g = (2*x for x in range(5))

sum(g)

# list
l = [2*x for x in range(5)]

# sets
s = {2*x for x in range(5)}

# dictionaries
d = {x:2*x for x in range(5)}

# 

import itertools

# For HW
# Look at itertools.groupby


c = itertools.count()

next(c)

max(c)

# Files in Python

datafile = "/Users/clark/projects/sta141c-winter19/data/sorted_data.csv"

# The with denotes a context manager.
with open(datafile) as f:
    everything = f.readlines()

# This is not the right way :(

import csv

f = open(datafile)

# Context manager will call:
# close(f)

reader = csv.reader(f)

row = next(reader)

# What are the types of the elements?
[type(x) for x in row]

# Get the first digit of the last column.

s = "314159"

s[0]

# Accessing the data
with open(datafile) as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)

# Making the change
with open(datafile) as f:
    reader = csv.reader(f)
    for row in reader:
        row[-1] = row[-1][0] 
        print(row)

# Save the change we made
with open(datafile) as f:
    with open("output.csv", "w") as outfile:
        writer = csv.writer(outfile)
        reader = csv.reader(f)
        for row in reader:
            row[-1] = row[-1][0] 
            writer.writerow(row)

