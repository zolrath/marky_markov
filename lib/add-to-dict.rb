#!/usr/bin/env ruby -i
require_relative 'marky-markov/markov-dictionary'
require_relative 'marky-markov/persistent-dictionary'

if __FILE__ == $0
  unless ARGV[0].nil?
    pers_dict = PersistentDictionary.new('dictionary')
    pers_dict.parse_source(ARGV[0])
    pers_dict.save_dictionary!
  end
end
