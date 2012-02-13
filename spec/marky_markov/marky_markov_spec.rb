require 'spec_helper'

describe MarkyMarkov do
  before(:each) do
    @textsource = "spec/data/test.txt"
    @onedictcompare = { ["The"] => ["cat"],
                        ["cat"] => ["likes"],
                        ["likes"] => ["pie"],
                        ["pie"] => ["and"],
                        ["and"] => ["chainsaws"],
                        ["chainsaws"] => ["!"]}
    @twodictcompare = {["The", "cat"] => ["likes"],
                       ["and", "chainsaws"] => ["!"],
                       ["cat", "likes"] => ["pie"],
                       ["likes", "pie"] => ["and"],
                       ["pie", "and"] => ["chainsaws"]}
  end

  context "TemporaryDictionary" do
    before(:each) do
      @dictionary = MarkyMarkov::TemporaryDictionary.new
    end

    it "should be able to parse a string" do
     @dictionary.parse_string "The cat likes pie and chainsaws!"
      @dictionary.dictionary.should eql(@twodictcompare)
    end

    it "should generate the right number of sentences" do
      @dictionary.parse_string "Hey man. How are you doing? Let's get pie!"
      sentence = @dictionary.generate_5_sentences
      sentence.should have(5).scan(/[.?!]/)
    end

    it "should create the right number of words" do
      @dictionary.parse_string "Hey man. How are you doing? Let's get pie!"
      sentence = @dictionary.generate_10_words
      sentence.split.should have(10).words
    end
  end

  context "PersistentDictionary" do
    before do
      @dictionary = MarkyMarkov::Dictionary.new("spec/data/temptextdict")
      @dictionary.parse_file "spec/data/test.txt"
    end

    it "should be able to save a dictionary" do
      @dictionary.save_dictionary!.should eql(true)
    end

    it "should be able to load an existing dictionary" do
      otherdict = MarkyMarkov::Dictionary.new("spec/data/textdictcompare")
      @dictionary.dictionary.should eql(otherdict.dictionary)
    end

    it "should load the saved dictionary" do
      @dictionary.dictionary.should include(@twodictcompare)
    end

    after do
      PersistentDictionary.delete_dictionary!(@dictionary)
    end
  end
end
