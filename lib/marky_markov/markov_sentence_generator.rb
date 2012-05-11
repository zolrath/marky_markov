# Messing about with the NullObject pattern, can't apply it in too many
# places in this one. Need to evaluate what else could be used in this
# aside from my first instinct of defaulting to []
# @private
class NullObject # :nodoc:
  def method_missing (*args, &block)
    self
  end
  def nil?; true; end
  def <<(*); end
  def to_str; end
  def to_ary; []; end
end

# @private
NULL_OBJECT = NullObject.new # :nodoc:

# @private
class EmptyDictionaryError < Exception # :nodoc:
end

# @private
class MarkovSentenceGenerator # :nodoc:
  def initialize(dictionary)
    @dictionary = dictionary
    @depth = @dictionary.depth
  end

  # Returns a random word via picking a random key from the dictionary.
  # In the case of the TwoWordDictionary, it returns two words to ensure
  # that the sentence will have a valid two word string to pick the next
  # word from.
  # wordslength
  # @return [String] a string containing a random dictionary key.
  def random_word
    words = @dictionary.dictionary.keys
    words[rand(words.length)]
  end

  # Generates a random capitalized word via picking a random key from the
  # dictionary and recurring if the word is lowercase.
  #
  # (see #random_word)
  def random_capitalized_word
    attempts = 0
    # If you don't find a capitalized word after 15 attempts, just use
    # a lowercase word as there may be no capitals in the dicationary.
    until attempts > 15
      attempts += 1
      words = @dictionary.dictionary.keys
      random_choice = words[rand(words.length)]
      if random_choice[0] =~ /[A-Z]/
        return random_choice
      end
    end
    random_word
  end

  # Returns a word based upon the likelihood of it appearing after the supplied word.
  #
  def weighted_random(lastword)
    # If word has no words in its dictionary (last word in source text file)
    # have it pick a random word to display instead.
    @dictionary.dictionary.fetch(lastword, NULL_OBJECT).sample
  end

  def punctuation?(word)
    ( word =~ /[!?]/ || word == '.' )
  end

  # Generates a sentence of (wordcount) length using the weighted_random function.
  #
  # @param [Int] wordcount The number of words you want the generated string to contain.
  # @return [String] the words, hopefully forming sentences generated.
  def generate(wordcount)
    if @dictionary.dictionary.empty?
      raise EmptyDictionaryError.new("The dictionary is empty! Parse a source file/string!")
    end
    sentence = []
    sentence.concat(random_capitalized_word)
    (wordcount-1).times do
      word = weighted_random(sentence.last(@depth))
      if punctuation?(word)
        sentence[-1] = sentence.last.dup << word
        sentence.concat(random_capitalized_word)
      elsif word.nil?
        sentence.concat(random_capitalized_word)
      else
        sentence << word
      end
    end
    sentence.pop(sentence.length-wordcount)
    sentence.join(' ')
  end

  # Generates a (sentencecount) sentences using the weighted_random function.
  #
  # @param [Int] sentencecount The number of sentences you want the generated string to contain.
  # @return [String] the sentence(s) generated.
  def generate_sentence(sentencecount)
    if @dictionary.dictionary.empty?
      raise EmptyDictionaryError.new("The dictionary is empty! Parse a source file/string!")
    end
    sentence = []
    # Find out how many actual keys are in the dictionary.
    key_count = @dictionary.dictionary.keys.length
    # If less than 30 keys, use that plus five as your maximum sentence length.
    maximum_length = key_count < 30 ? key_count + 5 : 30
    sentencecount.times do
      wordcount = 0
      sentence.concat(random_capitalized_word)
      until (punctuation?(sentence.last[-1])) || wordcount > maximum_length
        wordcount += 1
        word = weighted_random(sentence.last(@depth))
        if punctuation?(word)
          sentence[-1] = sentence.last.dup << word
        else
          sentence << word
        end
      end
    end
    sentence.join(' ')
  end
end
