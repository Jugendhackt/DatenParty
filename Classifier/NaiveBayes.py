	#!/usr/bin/python
	# -*- coding: utf-8 -*-

import sys
import json
import constants

class NaiveBayes():

	"""
		Naive bayes classifier judging a given text to be trustworthy or not 
		based upon whether the vagueness suggested by key words it contains is above
		a given threshhold, assuming the occurences of two arbitrary words in a 
		trustworthy text are strictly independet from one another.
	"""

	def __init__(self, article = ""):
		""" 
			Takes a string article and a dictionary track of past statistics as well as an optional 
			validity threshhold and returns the probability of a given article being trustworthy.
		"""
		self.article = article
		self.tokens = []
		try:
			with open(constants.MEMORY_PATH) as dataFile:
				self.occurences = json.load(dataFile)
		except IOError:
			return 0

	def tokenize(self):
		""" Tokenizes given plain text source """
		for word in self.article.split():
			if word[0] in constants.NOT_WORD_CHARS:
				word = word[1:]
			if word[-1] in constants.NOT_WORD_CHARS:
				word = word[:-1]
			self.tokens.append(word)

	def loadData(self, filePath):
		""" Reads counts of tokens in past trustworthy and untrustworthy texts """
		with open(filePath) as jsonFile:
			data = json.load(jsonFile)

	def getCount(self, label, word):
		try:
			if label in constants.LABELS:
				return float(self.occurences[label][word])
		except KeyError:
			return 0

	def wordTProb(self, word):
		if word not in self.occurences[constants.LABEL_TRUST].keys() and word not in self.occurences[constants.LABEL_NOTRUST].keys():
			return 0
		else:
			# print word
			occurencesOfWordInT = self.getCount(constants.LABEL_TRUST, word)
			occurencesOfWordInNT = self.getCount(constants.LABEL_NOTRUST, word)
			numberOfArticles = float(self.occurences[constants.ARTICLES])
			numberOfTArticles = float(self.occurences[constants.TRUSTED_ARTICLES])
			numberOfNTArticles = float(self.occurences[constants.ARTICLES] - self.occurences[constants.TRUSTED_ARTICLES])
			pWordInT = occurencesOfWordInT / numberOfTArticles
			pArtIsT = numberOfTArticles / numberOfArticles
			pWordInNT = occurencesOfWordInNT / numberOfNTArticles
			pArtIsNT = numberOfNTArticles / numberOfArticles
			pArtIsTWithWord = pWordInT * pArtIsT / (pWordInT * pArtIsT + pWordInNT * pArtIsNT)
			# print "P(T|W) =", pArtIsTWithWord, ", P(W|T) =", pWordInT, ", P(T) =", pArtIsT, "P(W|-T) =", pWordInNT, ", P(-T) =", pArtIsNT
			return pArtIsTWithWord

	def wordNProb(self, word):
		return 1 - self.wordTProb(word)

	def exceedsThreshhold(self, tProb):
		if tProb > constants.T_THRESHHOLD:
			return 1
		return 0

	def determine(self):
		tProb = 1.0
		nProb = 1.0
		for token in self.tokens:
			tProb *= self.wordTProb(token)
			nProb *= self.wordNProb(token)
		if tProb > 0.0:
			tProb /= (tProb + nProb)
		if self.exceedsThreshhold(tProb):
			print "Trustworthy."
		else:
			print "Untrustworthy."
		return tProb

def execute(article):
	nb = NaiveBayes(article)
	nb.tokenize()
	return nb.determine()

if __name__ == "__main__":
	print execute(open(sys.argv[1]).read())