#!/usr/bin/env ruby -i
#A Markov Chain generator.

require_relative 'marky_markov/persistent_dictionary'
require_relative 'marky_markov/two_word_sentence_generator'

module MarkyMarkov
  VERSION = '0.1.0'

  class TemporaryDictionary
    def initialize
      @dictionary = TwoWordDictionary.new
      @sentence = TwoWordSentenceGenerator.new(@dictionary)
    end
    def parse_file(location)
      @dictionary.parse_source(location, true)
    end
    def parse_string(string)
      @dictionary.parse_source(string, false)
    end
    def generate_n_words(wordcount)
      @sentence.generate(wordcount)
    end
  end

  class Dictionary < TemporaryDictionary
    def initialize(location)
      @dictionary = PersistentDictionary.new(location)
      @sentence = TwoWordSentenceGenerator.new(@dictionary)
    end
    def save_dictionary!
      @dictionary.save_dictionary!
    end
    def self.delete_dictionary!(location)
      PersistentDictionary.delete_dictionary!(location)
    end
  end
end
