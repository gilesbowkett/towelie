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
  it "returns no false positives when identifying duplication"
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
  it "isolates duplicated blocks" do
    duplicated_block =<<DUPLICATE_BLOCK
def bar
  "something non-unique"
end
DUPLICATE_BLOCK
    duplicated("spec/test_data").should == duplicated_block
  end
  it "reports unique code" do
    unique_block =<<UNIQUE_BLOCK
def foo
  "still unique"
end
def baz
  "also unique"
end
def foo
  "something unique"
end
UNIQUE_BLOCK
    unique("spec/test_data").should == unique_block
  end
  it "reports distinct methods with the same name" do
    homonym_block =<<HOMONYM_BLOCK
def foo
  "still unique"
end
def foo
  "something unique"
end
HOMONYM_BLOCK
    homonyms("spec/test_data").should == homonym_block
  end
end
