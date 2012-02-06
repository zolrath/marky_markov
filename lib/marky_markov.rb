#!/usr/bin/env ruby -i
#A Markov Chain generator.

require_relative 'marky_markov/persistent_dictionary'
require_relative 'marky_markov/two_word_sentence_generator'

# If used as a library
module MarkyMarkov
  VERSION = '0.1.0'
  def initialize(dictionary)
  end
end
