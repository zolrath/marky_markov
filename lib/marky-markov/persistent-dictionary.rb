require 'yajl'
require_relative 'two-word-dictionary'

class PersistentDictionary < TwoWordDictionary
  def initialize(dictionary)
    @dictionarylocation = dictionary
    self.open_dictionary
  end

  def open_dictionary
    if File.exists?(@dictionarylocation)
      File.open(@dictionarylocation,'r') do |f|
        @dictionary = Yajl::Parser.parse(f)
      end
    else
      @dictionary = {}
    end
  end

  def save_dictionary!
    json = Yajl::Encoder.encode(@dictionary)
    File.open(@dictionarylocation, 'w') do |f|
      f.puts json
    end
  end
end
