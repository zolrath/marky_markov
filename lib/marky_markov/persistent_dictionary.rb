require 'yajl'
require_relative 'markov_dictionary'

# @private
class PersistentDictionary < MarkovDictionary

  class DepthNotInRangeError < Exception
  end

  # Creates a PersistentDictionary object using the supplied dictionary file.
  #
  # @param [File] dictionary Name of dictionary file to create/open.
  # @param [Int] depth The dictionary depth. 2 word dictionary default.
  # @return [Object] PersistentDictionary object.
  attr_reader :dictionarylocation, :depth
  def initialize(dictionary, depth=2)
    @depth = depth
    unless (1..5).include?(depth)
      raise DepthNotInRangeError.new("Depth must be between 1 and 5")
    end
    @dictionarylocation = dictionary
    self.open_dictionary
  end


  # Opens the dictionary objects dictionary file.
  # If the file exists it assigns the contents to a hash, 
  # otherwise it creates an empty hash.
  def open_dictionary
    if File.exists?(@dictionarylocation)
      File.open(@dictionarylocation,'r').each do |f|
        @depth = f[0].to_i
        @dictionary = Yajl::Parser.parse(f[1..-1])
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
      f.puts @depth.to_s + json
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
