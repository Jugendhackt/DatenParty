#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import json
from pprint import pprint

class NaiveBayes():

	"""
		Naive bayes classifier judging a given text be trustworthy or not 
		based upon whether the vagueness suggested by key words it contains is above
		a given threshhold, assuming the occurence of two arbitrary words in a 
		trustworthy text is strictly independet from one another's.
	"""

	def __init__(self, filePath, tThreshhold = 0.90):
		try:
			self.file = open(filePath, "r")
		except IOError:
			return 0
		self.NOT_WORD_CHARS = ["\"", "'", ".", ",", "(", ")", "<", ">", "{", "}"]
		self.T_THRESHHOLD = tThreshhold
		self.tokens = []
		# self.frequencies = {}		# maps token keys to dict {label: count}
		# self.occurences = self.loadCounts(countsFilePath)	
		self.occurences = {	"articles" : 100, "tArticles" : 87, 								# number of articles and number of trustworthy articles (t-articles)
							"t" : {"Handwerk" : 4, "Inhalt" : 12, "gut" : 31, "wichtig" : 37},	# occurences of a token in distinct t-articles
							"nt" : {"Handwerk" : 1, "Inhalt" : 13, "gut" : 2, "wichtig" : 5}}	# occurences of a token in distinct nt-articles

	def setThreshhold(self, threshhold):
		self.T_THRESHHOLD = threshhold

	def tokenize(self):
		""" Tokenizes given plain text source """
		lines = list(self.file)
		for line in lines:
			for word in line.split():
				if word[0] in self.NOT_WORD_CHARS:
					word = word[1:]
				if word[-1] in self.NOT_WORD_CHARS:
					word = word[:-1]
				# print word
				self.tokens.append(word)

	def loadCounts(self, filePath):
		""" Reads counts of tokens in past trustworthy and untrustworthy texts """
		with open(filePath) as jsonFile:
			countData = json.load(jsonFile)
		pprint(countData)

	def wordTProb(self, word):
		if word not in self.occurences["t"].keys() and word not in self.occurences["nt"].keys():
			return 0
		else:
			#print word
			#print self.occurences
			#print self.occurences["t"][word]
			#print self.occurences["tArticles"] 
			#print 4/87
			occurencesOfWordInT = float(self.occurences["t"][word])
			occurencesOfWordInNT = float(self.occurences["nt"][word])
			numberOfArticles = float(self.occurences["articles"])
			numberOfTArticles = float(self.occurences["tArticles"])
			numberOfNTArticles = float(self.occurences["articles"] - self.occurences["tArticles"])
			pWordInT = occurencesOfWordInT / numberOfTArticles
			pArtIsT = numberOfTArticles / numberOfArticles
			pWordInNT = occurencesOfWordInNT / numberOfNTArticles
			pArtIsNT = numberOfNTArticles / numberOfArticles
			pArtIsTWithWord = pWordInT * pArtIsT / (pWordInT * pArtIsT + pWordInNT * pArtIsNT)
			print "P(T|W) =", pArtIsTWithWord, "P(W|T) =", pWordInT, ", P(T) =", pArtIsT, "P(W|-T) =", pWordInNT, ", P(-T) =", pArtIsNT
			return pArtIsTWithWord

	def wordNProb(self, word):
		return 1 - self.wordTProb(word)

	def exceedsThreshhold(self, tProb):
		if tProb > self.T_THRESHHOLD:
			return 1
		return 0

	def determine(self):
		tProb = 1
		nProb = 1
		for token in self.tokens:
			tProb *= self.wordTProb(token)
			nProb *= self.wordNProb(token)
		tProb /= (tProb + nProb)
		if self.exceedsThreshhold(tProb):
			print "Trustworthy."
			return 1
		print "Untrustworthy."
		return 0

if __name__ == "__main__":
	fileName = sys.argv[1]
	# jsonName = sys.argv[2]
	nb = NaiveBayes(fileName)
	nb.tokenize()
	# nb.loadCounts(jsonName)
	nb.determine()