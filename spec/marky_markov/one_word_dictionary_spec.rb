require 'spec_helper.rb'

describe OneWordDictionary do
  before(:each) do
    @textsource = "spec/test.txt"
    @dict = OneWordDictionary.new("Hello how are you doing today", false)
    @stringdict = {"Hello"   => {"how"        => 1},
                     "how"     => {"are"        => 1},
                     "are"     => {"you"        => 1},
                     "you"     => {"doing"      => 1},
                     "doing"   => {"today"      => 1},
                     "today"   => {} }
    @textdict = {"The" => {"cat"=>1},
                 "and" => {"chainsaws"=>1},
                 "cat" => {"likes"=>1},
           "chainsaws" => {},
               "likes" => {"pie"=>1},
                 "pie" => {"and"=>1} }
  end

  it "can open a file" do
    @dict.open_source(@textsource).should_not be_nil
  end

  it "should give a FileNotFoundError if the file doesn't exist" do
    expect { @dict.open_source("thisisntreal") }.to 
    raise_error(OneWordDictionary::FileNotFoundError,"thisisntreal does not exist!")
  end

  it "can add a word to the dictionary" do
    @dict.add_word("to", "be")
    @dict.dictionary.should include("to" => {"be" => 1})
  end

  it "create a dictionary via parsing a text file" do
    @dict.dictionary = {}
    @dict.parse_source(@textsource)
    @dict.dictionary.should eql(@textdict)
  end

  it "builds a one word dictionary properly" do
    @dict.dictionary.should eql(@stringdict)
  end
end
