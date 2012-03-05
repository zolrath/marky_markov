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
      -> {emptydict.generate_10_sentences}.should raise_error(EmptyDictionaryError)
    end

    after do
      PersistentDictionary.delete_dictionary!(dictionary)
    end
  end
end
