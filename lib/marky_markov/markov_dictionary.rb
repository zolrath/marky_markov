class MarkovDictionary
  def initialize(source, file=true)
    @dictionary = {}
    self.parse_source(source, file)
  end

  def dictionary
    @dictionary
  end

  class FileNotFoundError < Exception
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

  def parse_source(source, file=true)
    # Special case for last word in source file as it has no words following it.
    contents = file ? open_source(source) : contents = source.split
    contents.each_cons(2) do |first, second|
      self.add_word(first, second)
    end
    @dictionary[(contents.last)] ||= Hash.new(0)
  end
end
