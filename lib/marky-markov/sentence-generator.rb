class SentenceGenerator
  def initialize(dictionary)
    @dictionary = dictionary
    @sentence = []
  end

  def random_word
    keys = @dictionary.keys
    keys[rand(keys.length)]
  end

  def weighted_random(lastword)
    # If word has no words in its dictionary (last word in source text file)
    # have it pick a random word to display instead.
    total = @dictionary[lastword].values.inject(0) { |sum, value| sum + value }
    return random_word if total.zero?

    random = rand(total)+1
    @dictionary[lastword].each do |word, occurs|
      random -= occurs
      if random <= 0
        return word
      end
    end
  end

  def generate(wordcount)
    @sentence << random_word
    wordcount.times do
      @sentence << weighted_random(@sentence.last)
    end
    @sentence.join(' ')
  end
end
