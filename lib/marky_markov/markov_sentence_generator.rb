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
  def random_capitalized_word
    keys = @dictionary.dictionary.keys
    x = keys[rand(keys.length)]
    if /[A-Z]/ =~ x[0]
      return x
    else
      random_capitalized_word
    end
  end

  # Returns a word based upon the likelyhood of it appearing after the supplied word.
  # 
  def weighted_random(lastword)
    # If word has no words in its dictionary (last word in source text file)
    # have it pick a random word to display instead.
    @dictionary.dictionary.fetch(lastword, random_word)
      total = @dictionary.dictionary[lastword].values.inject(:+)
      return random_word if total.nil?
      random = rand(total)+1
      @dictionary.dictionary[lastword].each do |word, occurs|
        random -= occurs
        if random <= 0
          return word
        end
      end
  end

  # Generates a sentence of (wordcount) length using the weighted_random function.
  #
  def generate(wordcount)
    sentence = []
    sentence.concat(random_capitalized_word.split)
    (wordcount-1).times do
      sentence.concat(weighted_random(sentence.last(@depth).join(' ')).split)
    end
    sentence.pop(sentence.length-wordcount)
    sentence.join(' ')
  end
end
