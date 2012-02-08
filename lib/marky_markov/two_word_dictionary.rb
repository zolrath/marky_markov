require_relative 'one_word_dictionary'

# @private
class TwoWordDictionary < OneWordDictionary
  # Given a source of text, be it a text file (file=true) or a string (file=false)
  # it will add all the words within the source to the markov dictionary.
  #
  # @example Add a text file
  #   parse_source("text.txt")
  # @example Add a string
  #   parse_source("Hi, how are you doing?", false)
  def parse_source(source, file=true)
    contents = file ? open_source(source) : contents = source.split
    contents.each_cons(3) do |first, second, third|
       self.add_word("#{first} #{second}", third)
    end
    @dictionary[contents.last(2).join(' ')] ||= Hash.new(0)
  end
end
