require 'lib/towelie'
include Towelie

describe Towelie do
  it "scans a directory, returning a list of files" do
    files("spec/test_data").sort.should == ["spec/test_data/first_file.rb",
                                            "spec/test_data/second_file.rb"]
  end
  it "identifies duplication" do
    pending
    # duplication?("spec/test_data").should be_true
  end
  it "extracts :defn nodes" do
    load("spec/test_data")
    def_nodes.should == [
                          # second_file.rb
                          [:defn, :foo,
                            [:scope,
                              [:block, [:args], [:str, "still unique"]]]],
                          [:defn, :bar,
                            [:scope,
                              [:block, [:args], [:str, "something non-unique"]]]],
                          [:defn, :baz,
                            [:scope,
                              [:block, [:args], [:str, "also unique"]]]],

                          # first_file.rb
                          [:defn, :foo,
                            [:scope,
                              [:block, [:args], [:str, "something unique"]]]],
                          [:defn, :bar,
                            [:scope,
                              [:block, [:args], [:str, "something non-unique"]]]]
                        ]
  end
  it "returns no false positives when identifying duplication"
  it "isolates duplicated blocks" do
    pending
#     duplicated_block =<<DUPLICATE_BLOCK
# 
# def bar
#   "something non-unique"
# end
# 
# DUPLICATE_BLOCK
#     duplicated("spec/test_data").should == duplicated_block
  end
  it "reports unique code"
end
