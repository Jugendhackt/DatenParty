import requests
r = requests.get('http://loklak.org/api/search.json?timezoneOffset=-120&q=from%3Atagesschau')

def hashashtag(tweet):
    wordsoftweet = tweet.split()
    uselesshashtagsfile = open("uselesswords.txt")
    uselesshashtags = uselesshashtagsfile.read().split()
    for tag in uselesshashtags:
        ishashtagintext = tag in wordsoftweet
        if ishashtagintext:
            return True
    return False

loklakjson = r.json()
statusescounter = loklakjson["search_metadata"]["count"]
statusescounter = int(statusescounter)
for statuses in range(0,statusescounter):
    loklaktext = loklakjson["statuses"][statuses]["text"]
    if not loklaktext.startswith("@") and not hashashtag(loklaktext):
        print loklaktext