require 'spec_helper'

describe MarkyMarkov do
  context "TemporaryDictionary" do
    before(:each) do
      @textsource = "spec/test.txt"
      @dictionary = MarkyMarkov::TemporaryDictionary.new
      @onedictcompare = { ["The"] => ["cat"],
                       ["cat"] => ["likes"],
                     ["likes"] => ["pie"],
                       ["pie"] => ["and"],
                       ["and"] => ["chainsaws"],
                 ["chainsaws"] => []}
      @twodictcompare = {["The", "cat"] => ["likes"],
                   ["and", "chainsaws"] => [],
                       ["cat", "likes"] => ["pie"],
                       ["likes", "pie"] => ["and"],
                         ["pie", "and"] => ["chainsaws"]}
    end

    it "should be able to parse a string" do
      @dictionary.parse_string "The cat likes pie and chainsaws"
      @dictionary.dictionary.should eql(@twodictcompare)
    end

    it "should generate the right number of sentences" do
    end

    it "should create the right number of words" do
    end
  end

  context "PersistentDictionary" do
    before(:each) do
      @textsource = "spec/test.txt"
      @dictionary = MarkyMarkov::Dictionary.new(@textsource)
      @onedictcompare = { ["The"] => ["cat"],
                       ["cat"] => ["likes"],
                     ["likes"] => ["pie"],
                       ["pie"] => ["and"],
                       ["and"] => ["chainsaws"],
                 ["chainsaws"] => []}
      @twodictcompare = {["The", "cat"] => ["likes"],
                   ["and", "chainsaws"] => [],
                       ["cat", "likes"] => ["pie"],
                       ["likes", "pie"] => ["and"],
                         ["pie", "and"] => ["chainsaws"]}
    end

    it "should load the saved dictionary" do
    end

    it "should be able to parse a string" do
      @dictionary.parse_string "The cat likes pie and chainsaws"
      @dictionary.dictionary.should include(@twodictcompare)
    end

    it "should generate the right number of sentences" do
    end

    it "should create the right number of words" do
    end
  end
end
