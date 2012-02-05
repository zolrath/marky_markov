class MarkovDictionary
  def initialize(source)
    @dictionary = {}
    self.parse_source(source)
  end

  class FileNotFoundError < Exception
  end

  def dictionary
    @dictionary
  end

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

  def parse_source(source)
    # Special case for last word in source file as it has no words following it.
    contents = open_source(source)
    (contents.length-1).times do |i|
      self.add_word(contents[i], contents[i+1])
    end
    @dictionary[(contents.last)] ||= Hash.new(0)
  end
end
