Marky Markov and the Funky Sentences
====================================

Marky Markov is an experiment in Markov Chain generation implemented
in Ruby. It can be used both from the command-line and as a library within your code.

NOTE: 0.3.0 now uses arrays with multiple entries per word instead of a
hash key for each word with the value representing number of occurences.
While a less elegant solution, it leads to much faster text generation.

# Installation

    gem install marky_markov

# Imported Module Usage

## Temporary Dictionary

A basic usage of the TemporaryDictionary, which parses strings and files into a
temporary dictionary that will not be saved to disk.

    require 'marky_markov'
    markov = MarkyMarkov::TemporaryDictionary.new
    markov.parse_string "These words will be added to the temporary dictionary."
    markov.parse_file "filename.txt"
    puts markov.generate_n_sentences 5
    puts markov.generate_n_words 200
    markov.clear! # Clear the temporary dictionary.
  
## Persistent Dictionary
    
Dictionary creates or opens a persistent dictionary at a location defined by its 
initalizer, and will allow you to build and save a dictionary over multiple runs.
to ensure existing files aren't overwritten, the system appends .mmd to the end
of the dictionary name.

    require 'marky_markov'
    markov = MarkyMarkov::Dictionary.new('dictionary') # Saves/opens dictionary.mmd
    markov.parse_file "ENV["HOME"]/Documents/largefileindocs.txt"
    markov.parse_file "anotherfileyay.txt"
    puts markov.generate_n_words 10
    puts markov.generate_n_sentences 2
    markov.save_dictionary! # Saves the modified dictionary/creates one if it didn't exist.

## generate_20_words

If you keep looking at generate_n_words or generate_n_sentences and wonder why you can't put a
number in there, well, you can!

    markov.generate_7_sentences
    markov.generate_20_words

The default dictionary depth is two words.
 `{["I", "hope"]    => ["this"],
  ["hope", "this"]  => ["makes"],
  ["this", "makes"] => ["sense"]}`
but it can be set to a depth between 1 and 5 upon dictionary creation,
though really any higher than 3 and it starts to simply print passages
from the source text.

    markov = MarkyMarkov::Dictionary.new('dictionary', 3)

creates a dictionary with a depth of three words.
`{["I", "hope", "this"]     => ["makes"],
  ["hope", "this", "makes"] => ["sense"]`

## Delete a Dictionary

If you want to delete a dictionary you call it upon the Dictionary class itself while
passing in the filename/location.

    MarkyMarkov::Dictionary.delete_dictionary!('dictionary')
    
OR you can pass in a MarkyMarkov::Dictionary object directly.

    MarkyMarkov::Dictionary.delete_dictionary!(markov)


# Command-Line Usage

## Build a Dictionary 

    marky_markov read textfile.txt

to build your word probability dictionary. You can run the command
on different files to continue adding to your dictionary file.


## Say Some Words

    marky_markov speak -c 3

Will use the dictionary to create three sentences. If no number
is passed it will default to five sentences..

## Temporary Dictionaries 

    marky_markov speak -s other-file.txt -c 8

Generates a temporary dictionary based on the source file passed to it
and uses that to speak. Here we're loading other-file.txt and
restricting the generated text to 8 sentences.

## STDIN, Pipe Away!

    echo "Hello, how are you" | marky_markov

Marky-Markov is compatible with other STDIN/STDOUT command-line
applications and can accept STDIN.

    marky_markov listen "Bullfighting is difficult on the moon"

You can also supply a string as an argument to generate the text with,
though the results are nonsense without a substantial text base to work
from.

    Usage: marky_markov COMMAND [OPTIONS]

    Commands:
        speak: Generate Markov Chain sentence (5 sentences by default)
        listen [sentence]: Generate Markov Chain sentence from supplied string.
        read [file]: Add words to dictionary from supplied text file

    Options
        -d, --dictionary LOCATION        Use custom dictionary location
        -c, --sentencecount NUMBER       Set number of sentences generated
        -s, --source FILE                Generate and use temporary dictionary from source text
            --reset                      WARNING: Deletes default dictionary.
        -h, --help                       Display this screen
