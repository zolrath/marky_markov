#!/usr/bin/env ruby -i
require_relative 'marky-markov/markov-dictionary'
require_relative 'marky-markov/sentence-generator'

dict = MarkovDictionary.new(ARGV[0])
sentence = SentenceGenerator.new(dict.dictionary)
puts sentence.generate(ARGV[1].to_i)
