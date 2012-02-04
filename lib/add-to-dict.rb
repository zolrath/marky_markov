#!/usr/bin/env ruby -i
require_relative 'marky-markov/markov-dictionary'
require_relative 'marky-markov/persistent-dictionary'

if __FILE__ == $0
  unless ARGV[0].nil?
    pers_dict = PersistentDictionary.new(ARGV[0], 'dictionary')
    pers_dict.save_dictionary!
  end
end
