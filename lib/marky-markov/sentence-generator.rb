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
    total = @dictionary[lastword].values.inject(0) { |sum, value| sum + value }
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
    wordcount.times do |_|
      @sentence << weighted_random(@sentence.last)
    end
    @sentence.join(' ')
  end
end
