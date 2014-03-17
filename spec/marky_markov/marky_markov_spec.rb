require 'spec_helper'
require 'marky_markov'

describe MarkyMarkov do

  let(:onedictcompare) {
    { ["The"] => ["cat"],
      ["cat"] => ["likes"],
      ["likes"] => ["pie"],
      ["pie"] => ["and"],
      ["and"] => ["chainsaws"],
      ["chainsaws"] => ["!"]}
  }
  let(:twodictcompare) {
    {["The", "cat"] => ["likes"],
     ["and", "chainsaws"] => ["!"],
     ["cat", "likes"] => ["pie"],
     ["likes", "pie"] => ["and"],
     ["pie", "and"] => ["chainsaws"]}
  }

  context "TemporaryDictionary" do
    let(:dictionary) { MarkyMarkov::TemporaryDictionary.new }

    it "should be able to parse a string" do
      dictionary.parse_string "The cat likes pie and chainsaws!"
      dictionary.dictionary.should eql(twodictcompare)
    end

    it "should generate the right number of sentences" do
      dictionary.parse_string "Hey man. How are you doing? Let's get pie!"
      sentence = dictionary.generate_5_sentences
      sentence.should have(5).scan(/[.?!]/)
    end

    it "should create the right number of words" do
      dictionary.parse_string "Hey man. How are you doing? Let's get pie!"
      sentence = dictionary.generate_10_words
      sentence.split.should have(10).words
    end

    it "should not choke on parsing empty string" do
      lambda {
        dictionary.parse_string ""
      }.should_not raise_error
    end

    it "should not choke on parsing nil" do
      lambda {
        dictionary.parse_string nil
      }.should_not raise_error
    end
    it "should raise EmptyDictionaryError if you try to generate from empty dictionary" do
      lambda {
        dictionary.parse_string nil
        dictionary.generate_1_sentences
      }.should raise_error(EmptyDictionaryError)
    end

    context "if the sentence doesn't finish with a punctuation" do
      # null objects?
      it "should not have trailing spaces in a row" do
        dictionary.parse_string "I have a pen somewhere "
        dictionary.generate_4_sentences.should_not match( /  / )
      end
    end

    context "parsing web addresses" do
      it "should treat 'example.net' as single word" do
        dictionary.parse_string "i am at example.net now."
        dictionary.dictionary.values.should include( ['example.net'] )
      end
      it "should not break up 'example.net'" do
        dictionary.parse_string "i am at example.net now."
        dictionary.dictionary.values.should_not include( ['example'] )
      end
    end

    context "handling 'http://...'" do
      # previously, anything containing '.' was considered punctuation
      it "should generate sentence with space before 'http//:...'" do
        dictionary.parse_string "I'm viewing some stuff which is at http://example.net now."
        dictionary.generate_4_sentences.should_not match( /\whttp/ )
      end
    end
    context "when using key depth of 1 word" do
      let(:depth1dict) { MarkyMarkov::TemporaryDictionary.new(1) }
      it "should not raise 'negative array size'" do
        depth1dict.parse_string "short text. with many. full. stops."
        lambda {
          depth1dict.generate_15_words
        }.should_not raise_error
      end
    end
  end

  context "PersistentDictionary" do
    let!(:dictionary) do |dict|
      MarkyMarkov::Dictionary.new("spec/data/temptextdict").tap do |d|
        d.parse_file "spec/data/test.txt"
      end
    end

    it "should be able to save a dictionary" do
      dictionary.save_dictionary!.should eql(true)
    end

    it "should be able to load an existing dictionary" do
      otherdict = MarkyMarkov::Dictionary.new("spec/data/textdictcompare")
      dictionary.dictionary.should eql(otherdict.dictionary)
    end

    it "should load the saved dictionary" do
      dictionary.dictionary.should include(twodictcompare)
    end

    it "should have the correct failure when dictionary is empty: words" do
      emptydict = MarkyMarkov::Dictionary.new("spec/data/nothing")
      expect {emptydict.generate_10_words}.to raise_error(EmptyDictionaryError)
    end

    it "should have the correct failure when dictionary is empty: sentences" do
      emptydict = MarkyMarkov::Dictionary.new("spec/data/nothing")
      expect {emptydict.generate_10_sentences}.to raise_error(EmptyDictionaryError)
    end

    after do
      PersistentDictionary.delete_dictionary!(dictionary)
    end
  end
end
