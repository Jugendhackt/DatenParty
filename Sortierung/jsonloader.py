import requests
import json
import datetime
import random
r = requests.get('http://loklak.org/api/search.json?timezoneOffset=-120&q=from%3Atagesschau')
t = requests.get('http://loklak.org/api/search.json?timezoneOffset=-120&q=from%3Azeitonline')


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
zeitjson = t.json()
statuseszeitcounter = zeitjson["search_metadata"]["count"]
statusescounter = loklakjson["search_metadata"]["count"]
statuseszeitcounter =int(statuseszeitcounter) 
statusescounter = int(statusescounter)
for statuses in range(0,statusescounter):
    loklaktext = loklakjson["statuses"][statuses]["text"]
    createdat = loklakjson["statuses"][statuses]["created_at"]
    createdat = createdat[:-5]
    createdat = datetime.datetime.strptime(createdat,"%Y-%m-%dT%H:%M:%S")
    createdat = createdat.strftime("%H:%M:%S")
    name = loklakjson["statuses"][statuses]["user"]["screen_name"]
    profilimageurl = loklakjson["statuses"][statuses]["user"]["profile_image_url_https"]
    link = loklakjson["statuses"][statuses]["link"]
    trustlevel = random.uniform(0.2, 1.0)
    id = loklakjson["statuses"][statuses]["id_str"]
    if not loklaktext.startswith("@") and not hashashtag(loklaktext):
        tweet = {"tweet":loklaktext, "date":createdat, "profilname":name, "profilimage":profilimageurl, "tweetid":id, "tweetlink":link, "trustlevel":trustlevel}
        tweetlist.append(tweet)
for statusescounterzeit in range(0,statuseszeitcounter):
    zeittext = zeitjson["statuses"][statusescounterzeit]["text"]
    createdatzeit = zeitjson["statuses"][statusescounterzeit]["created_at"]
    createdatzeit = createdatzeit[:-5]
    createdatzeit = datetime.datetime.strptime(createdatzeit,"%Y-%m-%dT%H:%M:%S")
    createdatzeit = createdatzeit.strftime("%H:%M:%S")
    namezeit = zeitjson["statuses"][statusescounterzeit]["user"]["screen_name"]
    profilimageurlzeit = zeitjson["statuses"][statusescounterzeit]["user"]["profile_image_url_https"]
    linkzeit = zeitjson["statuses"][statusescounterzeit]["link"]
    trustlevelzeit = random.uniform(0.2, 1.0)
    idzeit = zeitjson["statuses"][statusescounterzeit]["id_str"]
    if not loklaktext.startswith("@") and not hashashtag(zeittext):
        zeittweets = {"tweet":zeittext, "date":createdatzeit, "profilname":namezeit, "profilimage":profilimageurlzeit, "tweetid":idzeit, "tweetlink":linkzeit, "trustlevel":trustlevelzeit}
        tweetlist.append(zeittweets)

fp = open("tweets.json", "w")
tweetlist.sort(key=lambda t: t["date"] , reverse=True)
json.dump(tweetlist, fp)
fp.close()       