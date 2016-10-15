#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import json
import constants
import copy

class TrainingHandler():

	def __init__(self):
		self.tokens = []
		self.occurences = {}

	def loadData(self):
		try:
			with open(constants.MEMORY_PATH) as dataFile:
				self.occurences = json.load(dataFile)
		except IOError:
			return 0

	def tokenize(self, article):
		""" Tokenizes given plain text source """
		for word in article.split():
			if word[0] in constants.NOT_WORD_CHARS:
				word = word[1:]
			if word[-1] in constants.NOT_WORD_CHARS:
				word = word[:-1]
			self.tokens.append(word)

	def train(self, article = "", label = ""):
		""" Tokenizes words and stores them according to label of source """
		self.loadData()
		self.tokenize(article)
		newData = copy.deepcopy(self.occurences)
		if label == constants.LABEL_TRUST:
			newData[constants.TRUSTED_ARTICLES] += 1
			newData[constants.ARTICLES] += 1
		elif label == constants.LABEL_NOTRUST:
			newData[constants.ARTICLES] += 1
		else:
			return 0
		for token in self.tokens:
			try:
				newData[label][token] += 1
			except KeyError:
				newData[label][token] = 1
		# @TODO: update JSON file
		print self.occurences
		print newData
		with open(constants.MEMORY_PATH, 'w') as writeFile:
			json.dump(newData, writeFile)

def execute(article = "", label = ""):
	TrainingHandler().train(open(sys.argv[1]).read(), constants.LABEL_TRUST)

if __name__ == "__main__":
	th = TrainingHandler()
	th.train(open(sys.argv[1]).read(), constants.LABEL_TRUST)
		