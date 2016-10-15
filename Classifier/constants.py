# characters not taken into account when tokenizing articles
NOT_WORD_CHARS = ["\"", "'", ".", ",", "(", ")", "<", ">", "{", "}"]

# confidence threshhold in decimal above which an articles is considered trustworthy
T_THRESHHOLD = 0.9

# label with which trustworthy articles are labeled
LABEL_TRUST = "t"

# label with which untrustworthy articles are labeled
LABEL_NOTRUST = "nt"

# index under which the count of articles is stored
ARTICLES = "articles"

# index under which the count of trustworthy articles is stored
TRUSTED_ARTICLES = "tArticles"

# path of the JSON file in which all statistical learning progess is stored
MEMORY_PATH = "sample.json"