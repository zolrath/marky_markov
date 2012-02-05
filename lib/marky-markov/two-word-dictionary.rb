require_relative 'markov-dictionary'

class TwoWordDictionary < MarkovDictionary
  def parse_source(source)
    contents = open_source(source)
    contents.each_cons(3) do |first, second, third|
      self.add_word("#{first} #{second}", third)
    end
    @dictionary[contents.last(2).join(' ')] ||= Hash.new(0)
  end
end
