require 'lib/towelie'
include Towelie

describe Towelie do
  it "scans a directory, returning a list of files" do
    files("spec/test_data").sort.should == ["spec/test_data/first_file.rb",
                                            "spec/test_data/second_file.rb"]
  end
  it "reports duplication in a set of files" do
    duplication?("spec/test_data").should be_true
  end
  it "reports unique code"
end
