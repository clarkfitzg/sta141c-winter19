#!/usr/bin/env python3
"""
Print out the unique elements from stdin.
"""

from sys import stdin, stdout

# This is pretty confusing.

# The set of unique lines
result = set(stdin)

# Remove the newline separator
result = {x.strip() for x in result}

output = "

sys.stdout.writelines(elements)

#for e in elements:
#    stdout.write(e)
