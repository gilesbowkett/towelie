require 'lib/towelie'

describe Towelie do
  before(:each) do
    @towelie = Towelie.new
  end

  it "isolates raw duplicated blocks, showing metadata, given one duplicate" do
    duplicate_block =<<DUPLICATE_BLOCK
found in:
  spec/test_data/second_file.rb
  spec/test_data/first_file.rb

def bar
  "something non-unique"
end

DUPLICATE_BLOCK

    @towelie.parse("spec/test_data")
    @towelie.duplicates.should == duplicate_block
  end

  it "isolates raw duplicated blocks, showing metadata, given multiple duplicates" do
    duplicate_block =<<DUPLICATE_BLOCK
found in:
  spec/multiple_duplicates/third_file.rb
  spec/multiple_duplicates/first_file.rb

def foo
  "something also non-unique"
end

found in:
  spec/multiple_duplicates/second_file.rb
  spec/multiple_duplicates/first_file.rb

def bar
  "something non-unique"
end

DUPLICATE_BLOCK

    @towelie.parse("spec/multiple_duplicates")
    @towelie.duplicates.should == duplicate_block
  end
end
