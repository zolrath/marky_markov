class MarkovDictionary
  def initialize
    @dictionary = {}
    self.parse_sentence
  end

  def add_word(rootword, followedby)
    @dictionary[rootword] ||= Hash.new(0)
    @dictionary[rootword][followedby] += 1
  end

  def read_file(filename)
    File.open(filename, "r").read.split
  end

  def parse_sentence()
    @contents = read_file("frank.txt")
    (@contents.length-1).times do |i|
      self.add_word(@contents[i], @contents[i+1])
    end
  end

  def chain
    @dictionary
  end
end

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

dict = MarkovDictionary.new
sentence = SentenceGenerator.new(dict.chain)
puts sentence.generate(100)
