import requests
import sys
import os
import json
import operator

lines = []
r = requests.get('http://loklak.org/api/search.json?timezoneOffset=-120&q=from%3Atagesschau')
lines = r.json()

def extract_time():
    try:
        # Also convert to int since update_time will be string.  When comparing
        # strings, "10" is smaller than "2".
        return int(json["statuses"][0]["created_at"])
    except KeyError:
        return 0

# lines.sort() is more efficient than lines = lines.sorted()
lines.sort(key=extract_time, reverse=True)