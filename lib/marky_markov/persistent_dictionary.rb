require 'msgpack'
require_relative 'markov_dictionary'

# @private
class PersistentDictionary < MarkovDictionary # :nodoc:

  class DepthNotInRangeError < Exception # :nodoc:
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
      raise DepthNotInRangeError.new("Depth must be between 1 and 5. For best results, use 2.")
    end
    @dictionarylocation = dictionary
    @split_words = /([.?!])|[\s]+/
    @split_sentence = /(?<=[.!?])\s+/
    self.open_dictionary
  end


  # Opens the dictionary objects dictionary file.
  # If the file exists it assigns the contents to a hash, 
  # otherwise it creates an empty hash.
  def open_dictionary
    if File.exists?(@dictionarylocation)
      file = File.new(@dictionarylocation, 'rb').read
        @depth = file[0].to_i
        @dictionary = MessagePack.unpack(file[1..-1])
    else
      @dictionary = {}
    end
  end

  # Saves the PersistentDictionary objects @dictionary hash 
  # to disk in JSON format.
  def save_dictionary!
    packed = @dictionary.to_msgpack
    File.open(@dictionarylocation, 'wb') do |f|
      f.write @depth.to_s + packed
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
