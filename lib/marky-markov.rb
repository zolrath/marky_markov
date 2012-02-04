#!/usr/bin/env ruby -i
require_relative 'marky-markov/markov-dictionary'
require_relative 'marky-markov/sentence-generator'
require_relative 'marky-markov/two-word-dictionary'
require_relative 'marky-markov/two-word-sentence-generator'

if __FILE__ == $0
  file = ARGV[0] || "frank.txt"
  wordcount = ARGV[1] || 200

  dict = TwoWordDictionary.new(file)
  sentence = TwoWordSentenceGenerator.new(dict.dictionary)
  puts sentence.generate(wordcount.to_i)
end
