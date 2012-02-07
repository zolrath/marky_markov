# @private
class OneWordDictionary
  attr_accessor :dictionary
  def initialize
    @dictionary = {}
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

  def add_word(rootword, followedby)
    @dictionary[rootword] ||= Hash.new(0)
    @dictionary[rootword][followedby] ||= 0
    @dictionary[rootword][followedby] += 1
  end

  def parse_source(source, file=true)
    # Special case for last word in source file as it has no words following it.
    contents = file ? open_source(source) : contents = source.split
    contents.each_cons(2) do |first, second|
      self.add_word(first, second)
    end
    @dictionary[(contents.last)] ||= Hash.new(0)
  end
end
