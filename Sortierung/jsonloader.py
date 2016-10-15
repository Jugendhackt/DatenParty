import requests
r = requests.get('http://loklak.org/api/search.json?timezoneOffset=-120&q=from%3Acnnbrk')

loklakjson = r.json()
statusescounter = loklakjson["search_metadata"]["count"]
statusescounter = int(statusescounter)
for statuses in range(0,statusescounter):
    loklaktext = loklakjson["statuses"][statuses]["text"]
    if not loklaktext.startswith("@"):
        print loklaktext