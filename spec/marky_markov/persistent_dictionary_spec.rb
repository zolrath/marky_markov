require 'spec_helper'

describe PersistentDictionary do
  before do
    @dict = PersistentDictionary.new("spec/textdict.mmd")
    @dict.parse_source("spec/test.txt")
  end

  it "should be able to save a dictionary" do
     @dict.save_dictionary!.should eql(true)
end

  it "should be able to load an existing dictionary" do
    otherdict = PersistentDictionary.new("spec/textdictcompare.mmd")
     @dict.dictionary.should eql(otherdict.dictionary)
  end

  after do
    PersistentDictionary.delete_dictionary!("spec/textdict.mmd")
  end
end

