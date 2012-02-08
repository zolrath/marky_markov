Marky Markov and the Funky Sentences
====================================

Marky Markov is a naïve experiment in Markov Chain generation implemented
in Ruby. It can be used both from the command-line and as a library within your code.

# Installation

    gem install marky_markov

# Module Usage

A basic usage of the TemporaryDictionary, which parses strings and files into a
temporary dictionary that will not be saved to disk.

    require 'marky_markov'
    markov = MarkyMarkov::TemporaryDictionary.new
    markov.parse_string "These words will be added to the temporary dictionary."
    markov.parse_file "filename.txt"
    puts markov.generate_n_words 50
    puts markov.generate_n_words 3000
    markov.clear!
    
Dictionary creates or opens a persistent dictionary at a location defined by its 
initalizer, and will allow you to build and save a dictionary over multiple runs.
to ensure existing files aren't overwritten, the system appends .mmd to the end
of the dictionary name.

    require 'marky_markov'
    markov = MarkyMarkov::Dictionary.new('dictionary') # Saves/opens dictionary.mmd
    markov.parse_file "ENV["HOME"]/Documents/largefileindocs.txt"
    markov.parse_file "anotherfileyay.txt"
    puts markov.generate_n_words 10
    markov.save_dictionary! # Saves the modified dictionary/creates one if it didn't exist.

If you keep looking at generate_n_words and wonder why you can't put a
number in there, well, you can!

    markov.generate_20_words

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

    marky_markov speak -w 30

Will use the dictionary to create a 30 word long sentence. If no number
is passed it will default to 200 words.

## Temporary Dictionaries 

    marky_markov speak -s other-file.txt -w 20

Generates a temporary dictionary based on the source file passed to it
and uses that to speak. Here we're loading other-file.txt and
restricting the generated sentence to 20 words.

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
            speak: Generate Markov Chain sentence (default wordcount of 200)
            listen [sentence]: Generate Markov Chain sentence from supplied string.
            read [file]: Add words to dictionary from supplied text file
        Options
            -d, --dictionary FILE            Use custom dictionary location
            -w, --wordcount NUMBER           Set number of words generated
            -s, --source FILE                Generate and use temporary dictionary from source text
            -h, --help                       Display this screen
