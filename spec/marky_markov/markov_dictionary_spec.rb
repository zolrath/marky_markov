require 'spec_helper.rb'

describe MarkovDictionary do
  context "One Word Depth Dictionary" do
    before(:each) do
      @onetextsource = "spec/test.txt"
      @onedict = MarkovDictionary.new(1)
      @onedict.parse_source("The cat likes pie and chainsaws", false)
      @onetextdict = { ["The"] => ["cat"],
                       ["cat"] => ["likes"],
                     ["likes"] => ["pie"],
                       ["pie"] => ["and"],
                       ["and"] => ["chainsaws"],
                 ["chainsaws"] => []}
    end

    it "can open a file" do
      @onedict.open_source(@onetextsource).should_not be_nil
    end

    it "should give a FileNotFoundError if the file doesn't exist" do
      expect { @onedict.open_source("thisisntreal") }.to 
      raise_error(MarkovDictionary::FileNotFoundError,"thisisntreal does not exist!")
    end

    it "can add a word to the dictionary" do
      @onedict.add_word(["to"], "be")
      @onedict.dictionary.should include(["to"] => ["be"])
    end

    it "create a dictionary via parsing a text file" do
      @onedict.dictionary = {}
      @onedict.parse_source(@onetextsource)
      @onedict.dictionary.should eql(@onetextdict)
    end

    it "builds a one word dictionary properly" do
      @onedict.dictionary.should eql(@onetextdict)
    end
  end

  context "Two Word Dictionary" do
    before(:each) do
      @twodict = MarkovDictionary.new
      @twodict.parse_source("The cat likes pie and chainsaws", false)
      @twotextsource = "spec/test.txt"
      @twotextdict = {["The", "cat"] => ["likes"],
                  ["and", "chainsaws"] => [],
                      ["cat", "likes"] => ["pie"],
                      ["likes", "pie"] => ["and"],
                        ["pie", "and"] => ["chainsaws"]}
    end

    it "can add a word to the two-word dictionary" do
      @twodict.add_word(["Zebras", "like"], "kung-fu")
      @twodict.dictionary.should eql(@twotextdict.merge( {["Zebras", "like"] => ["kung-fu"]} ))
    end

    it "create a two-word dictionary via parsing a text file" do
      @twodict.dictionary = {}
      @twodict.parse_source(@twotextsource)
      @twodict.dictionary.should eql(@twotextdict)
    end
  end
end
