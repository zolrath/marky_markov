#!/usr/bin/env ruby -i
#A Markov Chain generator.

require 'optparse'
require_relative 'marky-markov/persistent-dictionary'
require_relative 'marky-markov/two-word-sentence-generator'

if __FILE__ == $0
  options = {}
  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: marky-markov COMMAND [OPTIONS]"
    opts.separator ""
    opts.separator "Commands:"
    opts.separator "    speak: Generate Markov Chain sentence (default wordcount of 200)"
    opts.separator "    listen [sentence]: Generate Markov Chain sentence from supplied string."
    opts.separator "    read [file]: Add words to dictionary from supplied text file"
    opts.separator ""
    opts.separator "Options"

    options[:dictionary] = 'dictionary'
    opts.on('-d', '--dictionary FILE', 'Set dictionary location') do |file|
      options[:dictionary] = file
    end

    options[:wordcount] = 200
    opts.on('-w', '--wordcount NUMBER', 'Set number of words generated') do |number|
      options[:wordcount] = number.to_i
    end

    options[:source] = nil
    opts.on('-s', '--source FILE',
            'Generate and use temporary dictionary from source text') do |file|
      options[:source] = file
    end

    opts.on('-h', '--help', 'Display this screen') do
      STDOUT.puts opt_parser
      exit
    end
  end

  opt_parser.parse!

  case ARGV[0]
  when "speak"
    if options[:source]
      dict = TwoWordDictionary.new(options[:source])
    else
      unless File.exists?(options[:dictionary])
        STDERR.puts "Dictionary file #{options[:dictionary]} does not exist. Cannot generate sentence."
        STDERR.puts "Please build a dictionary with read or use the --source option with speak."
        exit(false)
      end
      dict = PersistentDictionary.new(options[:dictionary])
    end
    sentence = TwoWordSentenceGenerator.new(dict.dictionary)
    STDOUT.puts sentence.generate(options[:wordcount])
  when "read"
    source = ARGV[1] || options[:source]
    dict = PersistentDictionary.new(options[:dictionary])
    dict.parse_source(source)
    dict.save_dictionary!
    STDOUT.puts "Added #{source} to dictionary."
  when "listen"
    dict = TwoWordDictionary.new((STDIN.tty? ? ARGV[1] : STDIN.read), false)
    sentence = TwoWordSentenceGenerator.new(dict.dictionary)
    STDOUT.puts sentence.generate(options[:wordcount])
  else
    unless STDIN.tty?
      dict = TwoWordDictionary.new(STDIN.read, false)
      sentence = TwoWordSentenceGenerator.new(dict.dictionary)
      STDOUT.puts sentence.generate(options[:wordcount])
    else
      STDOUT.puts opt_parser
    end
  end
end
