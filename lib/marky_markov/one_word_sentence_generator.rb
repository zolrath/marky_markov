class OneWordSentenceGenerator
  def initialize(dictionary)
    @dictionary = dictionary
  end

  def random_word
    keys = @dictionary.dictionary.keys
    keys[rand(keys.length)]
  end

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

  def generate(wordcount)
    sentence = []
    sentence << random_word
    (wordcount-1).times do
      sentence << weighted_random(sentence.last)
    end
    sentence.join(' ')
  end
end
