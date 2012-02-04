class TwoWordSentenceGenerator < SentenceGenerator
  def generate(wordcount)
    sentence = []
    x, y = random_word.split
    sentence << x << y
    (wordcount-1).times do
      sentence << weighted_random("#{sentence[sentence.length-2]} #{sentence.last}")
    end
    sentence.join(' ')
  end
end
