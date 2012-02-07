require 'yajl'
require_relative 'two_word_dictionary'

# @private
class PersistentDictionary < TwoWordDictionary
  def initialize(dictionary)
    @dictionarylocation = "#{dictionary}.mmd"
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
    true
  end

  def self.delete_dictionary!(dictionary=@dictionarylocation[0...-4])
    mmd = "#{dictionary}.mmd"
    if File.exists?(mmd)
      File.delete(mmd)
      "Deleted #{mmd}"
    end
    false
  end
end
