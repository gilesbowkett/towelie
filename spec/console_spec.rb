require 'lib/towelie'

describe Towelie do
  before(:each) do
    @towelie = Towelie.new(:console)
  end
  before (:all) do
    @duplicate_block =<<DUPLICATE_BLOCK
found in:
  spec/test_data/second_file.rb
  spec/test_data/first_file.rb

def bar
  "something non-unique"
end

DUPLICATE_BLOCK
  end

  it "isolates raw duplicated blocks, showing metadata, given one duplicate" do
    @towelie.parse("spec/test_data")
    @towelie.duplicated.should == @duplicate_block
  end
  it "isolates raw duplicated blocks, showing metadata, given multiple duplicates" do
    # @towelie.parse("spec/multiple_duplicates")
    # @towelie.duplicated.should == @duplicate_block
    pending
  end
end
