#!/bin/env python
#coding: utf8

import sys
import os
import json
import operator

#load json from file
lines = []
while True:
    line = sys.stdin.readline()
    if not line: break
    line = line.strip()
    json_obj = json.loads(line)
    lines.append(json_obj)

#sort json
lines = sorted(lines, key=lambda k: k['page']['update_time'], reverse=True)

#output result
for line in lines:
    print line
    
def extract_time(json):
    try:
        # Also convert to int since update_time will be string.  When comparing
        # strings, "10" is smaller than "2".
        return int(json['page']['update_time'])
    except KeyError:
        return 0

# lines.sort() is more efficient than lines = lines.sorted()
lines.sort(key=extract_time, reverse=True)