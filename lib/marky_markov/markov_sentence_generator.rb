# @private
class MarkovSentenceGenerator
  def initialize(dictionary)
    @dictionary = dictionary
    @depth = @dictionary.depth
  end

  # Returns a random word via picking a random key from the dictionary.
  # In the case of the TwoWordDictionary, it returns two words to ensure
  # that the sentence will have a valid two word string to pick the next
  # word from.
  #
  # @return [String] a string containing a random dictionary key.
  def random_word
    keys = @dictionary.dictionary.keys
    keys[rand(keys.length)]
  end

  # Generates a random capitalized word via picking a random key from the
  # dictionary and recurring if the word is lowercase.
  #
  # (see #random_word)
  def random_capitalized_word(attempts=0)
    keys = @dictionary.dictionary.keys
    x = keys[rand(keys.length)]
    if /[A-Z]/ =~ x[0]
      return x
    elsif attempts < 30
      # If you don't find a capitalized word after 30 attempts, just use
      # a lowercase word as there may be no capitals in the dicationary.
      random_capitalized_word(attempts+1)
    else
      random_word
    end
  end

  # Returns a word based upon the likelyhood of it appearing after the supplied word.
  # 
  def weighted_random(lastword)
    # If word has no words in its dictionary (last word in source text file)
    # have it pick a random word to display instead.
    if word = @dictionary.dictionary[lastword]
      word.sample
    end
  end

  # Generates a sentence of (wordcount) length using the weighted_random function.
  #
  # @param [Int] wordcount The number of words you want the generated string to contain.
  # @return [String] the words, hopefully forming sentences generated.
  def generate(wordcount)
    sentence = []
    sentence.concat(random_capitalized_word)
    (wordcount-1).times do
      if word = weighted_random(sentence.last(@depth))
        sentence << word
      else
        sentence.concat(random_capitalized_word)
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
    sentence = []
    sentencecount.times do
      # Find out how many actual keys are in the dictionary.
      key_count = @dictionary.dictionary.keys.length
      # If less than 30 keys, use that plus five as your maximum sentence length.
      maximum_length = key_count < 30 ? key_count + 5 : 30
      stop_at_index = sentence.count + maximum_length
      sentence.concat(random_capitalized_word)
      until (/[.!?]/ =~ sentence.last[-1])
        word = weighted_random(sentence.last(@depth))
        sentence << word unless word.nil?
        # If a word ending with a . ! or ?  isn't found after 30 words,
        # just add a period as there may be none in the dictionary.
        sentence[-1] << "." if word.nil? || sentence.count > stop_at_index
      end
    end
    sentence.join(' ')
  end
end
