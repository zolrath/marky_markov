require_relative 'markov-dictionary'

class TwoWordDictionary < MarkovDictionary
  def parse_source(source)
    contents = open_source(source)
    (contents.length-3).times do |i|
      rootword = "#{contents[i]} #{contents[i+1]}"
      self.add_word(rootword, contents[i+2])
    end
    @dictionary[contents.last(2).join(' ')] ||= Hash.new(0)
  end
end
