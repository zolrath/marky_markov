require 'spec_helper'

describe TwoWordDictionary do
  before(:each) do
    @dict = TwoWordDictionary.new("The cat likes pie and chainsaws", false)
    @textsource = "spec/test.txt"
    @stringdict = { "The cat"       => { "likes"     => 1},
                    "cat likes"     => { "pie"       => 1 },
                    "likes pie"     => {"and"        => 1 },
                    "pie and"       => { "chainsaws" => 1 },
                    "and chainsaws" => {} }
    @textdict = {"The cat"          => {"likes"      => 1},
                 "cat likes"        => {"pie"        => 1},
                 "likes pie"        => {"and"        => 1},
                 "pie and"          => {"chainsaws"  => 1},
                 "and chainsaws"    => {}}
  end

  it "can add a word to the two-word dictionary" do
    @dict.add_word("Zebras like", "kung-fu")
    @dict.dictionary.should eql(@stringdict.merge( {"Zebras like" => {"kung-fu" => 1}} ))
  end

  it "create a two-word dictionary via parsing a text file" do
    @dict.dictionary = {}
    @dict.parse_source(@textsource)
    @dict.dictionary.should eql(@textdict)
  end
end

