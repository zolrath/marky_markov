Marky Markov and the Funky Sentences
====================================

Marky Markov is a naïve experiment in Markov Chain generation implemented in Ruby.

Usage:
-------
As of now you must be in the /lib directory and run marky-markov.rb,
coming soon in Gem form.

First you must:
> ruby marky-markov.rb read textfile.txt
to build your word probability dictionary. You can run the command
multiple times to continue building up the same dictionary file.

> ruby marky-markov.rb speak -w 30
Will use the dictionary to create a 30 word long sentence. If no number
is passed it will default to 200 words.


> ruby marky-markov.rb speak -s other-file.txt -w 20
Generates a temporary dictionary based on the source file passed to it
and uses that to speak. Here we're loading other-file.txt and
restricting it to 20 words.

> echo "Hello, how are you" | ruby marky-markov.rb
Marky-Markov is compatible with other STDIN/STDOUT command-line
applications and can accept STDIN.

> ruby marky-markov.rb listen "Bullfighting is difficult on the moon"
You can also supply a string as an argument to generate the text with,
though the results are nonsense without a substantial text base to work
from.

Usage: marky-markov COMMAND [OPTIONS]

Commands:
    speak: Generate Markov Chain sentence (default wordcount of 200)
    listen [sentence]: Generate Markov Chain sentence from supplied string.
    read [file]: Add words to dictionary from supplied text file

Options
    -d, --dictionary FILE            Use custom dictionary location
    -w, --wordcount NUMBER           Set number of words generated
    -s, --source FILE                Generate and use temporary dictionary from source text
    -h, --help                       Display this screen
