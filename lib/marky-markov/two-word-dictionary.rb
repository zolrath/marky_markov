require_relative 'markov-dictionary'

class TwoWordDictionary < MarkovDictionary
  def parse_file
    # Special case for last word in source file as it has no words following it.
    @contents = open_file(@filename)
    (@contents.length-3).times do |i|
      rootword = "#{@contents[i]} #{@contents[i+1]}"
      self.add_word(rootword, @contents[i+2])
    end
  end
end
