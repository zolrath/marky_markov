Marky Markov and the Funky Sentences
====================================

Marky Markov is a naïve experiment in Markov Chain generation implemented in Ruby.
Right now it's a basic implementation but in time hopefully it will learn about actual sentence structure and be able to produce more intelligent sentences than 90% of the comments on YouTube.

Useage:
-------
As of now you must be in the /lib directory and run marky-markov.rb.
You can optionally pass it the name of a text file and the number of words to generate, if excluded it will default to "frank.txt" and 200 words.

>./marky-markov "other-file.txt" 100

would generate a 100 word long sentence with "other-file.txt" as its source.