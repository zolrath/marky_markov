require_relative 'one_word_sentence_generator'

class TwoWordSentenceGenerator < OneWordSentenceGenerator
  def generate(wordcount)
    sentence = []
    sentence.concat(random_word.split)
    (wordcount-1).times do
      sentence.concat(weighted_random(sentence.last(2).join(' ')).split)
    end
    sentence.pop(sentence.length-wordcount)
    sentence.join(' ')
  end
end
