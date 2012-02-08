# @private
class MarkovDictionary
  attr_accessor :dictionary, :depth
  def initialize(depth=2)
    @dictionary = {}
    @depth = depth
  end

  # If File does not exist.
  class FileNotFoundError < Exception
  end

  # Open supplied text file:
  def open_source(source)
    if File.exists?(source)
      File.open(source, "r").read.split
    else
      raise FileNotFoundError.new("#{source} does not exist!")
    end
  end

  # Given root word and what it is followed by, it adds them to the dictionary.
  #
  # @example Adding a word
  #   add_word("Hello", "world")
  def add_word(rootword, followedby)
    @dictionary[rootword] ||= Hash.new(0)
    @dictionary[rootword][followedby] ||= 0
    @dictionary[rootword][followedby] += 1
  end

  # Given a source of text, be it a text file (file=true) or a string (file=false)
  # it will add all the words within the source to the markov dictionary.
  #
  # @example Add a text file
  #   parse_source("text.txt")
  # @example Add a string
  #   parse_source("Hi, how are you doing?", false)
  def parse_source(source, file=true)
    contents = file ? open_source(source) : contents = source.split
    contents.each_cons(@depth+1) do |words|
       self.add_word(words[0..-2].join(' '), words[-1])
    end
    @dictionary[contents.last(@depth).join(' ')] ||= Hash.new(0)
  end
end
