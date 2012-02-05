#!/usr/bin/env ruby -i
require_relative 'marky-markov/markov-dictionary'
require_relative 'marky-markov/two-word-dictionary'
require_relative 'marky-markov/persistent-dictionary'
require_relative 'marky-markov/sentence-generator'
require_relative 'marky-markov/two-word-sentence-generator'

if __FILE__ == $0
  wordcount = ARGV[0] || 200
  source = ARGV[1]

  if source.nil? || source == "dictionary"
    if File.exists?('dictionary')
      dict = PersistentDictionary.new('dictionary')
    else
      puts "No source text or dictionary supplied."
    end
  else
    dict = TwoWordDictionary.new(source)
  end
  sentence = TwoWordSentenceGenerator.new(dict.dictionary)
  puts sentence.generate(wordcount.to_i)
end
