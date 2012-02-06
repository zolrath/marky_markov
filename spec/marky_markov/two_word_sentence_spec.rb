require 'spec_helper'

describe TwoWordSentenceGenerator do
  before(:each) do
    @dict = TwoWordDictionary.new("Hello man how are you today", false)
    @sentence = TwoWordSentenceGenerator.new(@dict)
  end

  it "generates a sentence of the appropriate length" do
    @sentence.generate(20).split.count.should eql(20)
  end
end
