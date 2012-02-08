require 'yajl'
require_relative 'two_word_dictionary'

# @private
class PersistentDictionary < TwoWordDictionary
  # Creates a PersistentDictionary object using the supplied dictionary file.
  #
  # @note Do not include the .mmd file extension in the name of the dictionary.
  #   It will be automatically appended.
  # @param [File] dictionary Name of dictionary file to create/open.
  # @return [Object] PersistentDictionary object.
  attr_reader :dictionarylocation
  def initialize(dictionary)
    @dictionarylocation = dictionary
    self.open_dictionary
  end

  # Opens the dictionary objects dictionary file.
  # If the file exists it assigns the contents to a hash, 
  # otherwise it creates an empty hash.
  def open_dictionary
    if File.exists?(@dictionarylocation)
      File.open(@dictionarylocation,'r') do |f|
        @dictionary = Yajl::Parser.parse(f)
      end
    else
      @dictionary = {}
    end
  end

  # Saves the PersistentDictionary objects @dictionary hash 
  # to disk in JSON format.
  def save_dictionary!
    json = Yajl::Encoder.encode(@dictionary)
    File.open(@dictionarylocation, 'w') do |f|
      f.puts json
    end
    true
  end

  # Deletes the supplied dictionary file.
  # Can either be passed the dictionary location and name, or a
  # PersistentDictionary object.
  def self.delete_dictionary!(dictionary)
    if dictionary.respond_to?(:dictionarylocation)
      dictionary = dictionary.dictionarylocation
    end
    if File.exists?(dictionary)
      File.delete(dictionary)
      "Deleted #{dictionary}"
    else
      "#{dictionary} does not exist."
    end
  end
end
