#!/usr/local/bin/python3.7

import sys, re

for line in sys.stdin:
    try:
        words = [x for x in re.split(r'\s+', line) if len(x)>0]
        for word in words:
            print(f'{word}\t{1}')
    except ValueError as e:
        continue
    