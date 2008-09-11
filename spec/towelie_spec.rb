require 'lib/towelie'
include Towelie

describe Towelie do
  it "scans a directory, returning a list of files" do
    files("spec/test_data").sort.should == ["spec/test_data/first_file.rb",
                                            "spec/test_data/second_file.rb"]
  end
  it "identifies duplication" do
    duplication?("spec/test_data").should be_true
  end
  it "reports unique code"
end
