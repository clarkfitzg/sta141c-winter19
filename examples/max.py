#!/usr/bin/env python3
"""
Return the max value.
"""

from sys import stdin

numbers = (float(x) for x in stdin)

mx = max(numbers)

print(mx)
