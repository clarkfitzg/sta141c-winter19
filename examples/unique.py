#!/usr/bin/env python3
"""
Print out the unique elements from stdin.
"""

from sys import stdin

elements = {x for x in stdin}

for e in elements:
    print(e)
