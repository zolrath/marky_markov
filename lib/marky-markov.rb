#!/usr/bin/env ruby -i
require_relative 'marky-markov/markov-dictionary'
require_relative 'marky-markov/sentence-generator'

file = ARGV[0] || "frank.txt"
wordcount = ARGV[1] || 200

dict = MarkovDictionary.new(file)
sentence = SentenceGenerator.new(dict.dictionary)
puts sentence.generate(wordcount.to_i)
