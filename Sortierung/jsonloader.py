import requests
import json
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

tweetlist = []
loklakjson = r.json()
statusescounter = loklakjson["search_metadata"]["count"]
statusescounter = int(statusescounter)
for statuses in range(0,statusescounter):
    loklaktext = loklakjson["statuses"][statuses]["text"]
    createdat = loklakjson["statuses"][statuses]["created_at"]
    name = loklakjson["statuses"][statuses]["user"]["screen_name"]
    profilimageurl = loklakjson["statuses"][statuses]["user"]["profile_image_url_https"]
    if not loklaktext.startswith("@") and not hashashtag(loklaktext):
        tweet = {"tweet":loklaktext, "date":createdat, "profilname":name, "profilimage":profilimageurl}
        tweetlist.append(tweet)
fp = open("tweets.json", "w")
json.dump(tweetlist, fp)
fp.close()       