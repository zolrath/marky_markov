# @private
class MarkovDictionary # :nodoc:
  attr_reader :dictionary, :depth
  def initialize(depth=2) @dictionary = {}
    @depth = depth
    @split_words = /(\.\s+)|(\.$)|([?!])|[\s]+/
    @split_sentence = /(?<=[.!?])\s+/
  end

  # If File does not exist.
  class FileNotFoundError < Exception # :nodoc:
  end

  # Open supplied text file:
  def open_source(source)
    if File.exists?(source)
      File.open(source, "r").read.split(@split_sentence)
    else
      raise FileNotFoundError.new("#{source} does not exist!")
    end
  end

  # Given root word and what it is followed by, it adds them to the dictionary.
  #
  # @example Adding a word
  #   add_word("Hello", "world")
  # @example Adding a multi-word dictionary
  #   add_word("You are", "awesome")
  def add_word(rootword, followedby)
    @dictionary[rootword] ||= []
    @dictionary[rootword] << followedby
  end

  # Given a source of text, be it a text file (file=true) or a string (file=false)
  # it will add all the words within the source to the markov dictionary.
  #
  # @example Add a text file
  #   parse_source("text.txt")
  # @example Add a string
  #   parse_source("Hi, how are you doing?", false)
  def parse_source(source, file=true)
    if !source.nil?
      contents = file ? open_source(source) : contents = source.split(@split_sentence)
    else
      contents = []
    end
    if( !contents.empty? && !['.', '!', '?'].include?( contents[-1].strip[-1] ) )
      contents[-1] = contents[-1].strip + '.'
    end
    contents.map! {|sentence| sentence.gsub(/["()]/,"")}
    contents.each do |sentence|
      sentence.split(@split_words).each_cons(@depth+1) do |words|
        self.add_word(words[0..-2], words[-1])
      end
    end
  end
end
