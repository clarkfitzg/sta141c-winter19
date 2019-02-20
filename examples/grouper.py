"""
Idea: Could show the progression to make this an increasingly general tool.

This script uses the first column in a csv file as a key and the second column as a value.
Run as 

$ python sorted_data.csv
"""

import sys
import csv
import itertools

#statistic = max

def numeric_range(x):
    """
    Find the minimum and maximum values that appear in an iterable object x

    >>> numeric_range([100, 0, 78])
    {'max': 100, 'min': 0}
    """
    i1, i2 = itertools.tee(x)
    result = {}
    result["min"] = min(i1)
    result["max"] = max(i2)
    return result


# argparse will let you use named arguments
#fname = sys.argv[1]

fname = "sorted_data.csv"
f = open(fname)
reader = csv.reader(f)
line = next(reader)
grouped = itertools.groupby(reader, key = lambda x: x[0])
g1 = next(grouped)

#list(g1[1])

values = (float(x[1]) for x in g1[1])
numeric_range(values)

# Iterators maintain state. Once they are exhausted we cannot go back.

# Iterators can be confusing when you don't know what's in them.
# list will take an iterator as input and materialize it in a list.

# We could get everything as 
# list(g1[1])

# Sometimes we don't want everything, so we can just select the first few elements.
# In R and bash we used head.
# For an iterator in Python we can use itertools.islice

list(itertools.islice(g1[1], 5))

result = {}
for g in grouped:
    values = (


if __name__ == "__main__":
    print("Testing")
    import doctest
    doctest.testmod()
