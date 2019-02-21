#!/usr/bin/env python3
"""
Print out the unique elements from stdin.
"""

import sys

#from sys import stdin, stdout

# elements = {x for x in stdin}

elements = set(sys.stdin)

sys.stdout.writelines(elements)

#for e in elements:
#    stdout.write(e)
