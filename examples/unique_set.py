#!/usr/bin/env python3
"""
Print out the unique elements from stdin.
"""

from sys import stdin, stdout

# The set of unique lines, including newline separator
result = set(sys.stdin)

sys.stdout.writelines(result)
