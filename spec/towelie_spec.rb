require 'lib/array'
require 'lib/towelie'
include Towelie

describe Towelie do
  before(:all) do
    @the_nodes = [
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
    @duplicated_block =<<DUPLICATE_BLOCK
def bar
  "something non-unique"
end

DUPLICATE_BLOCK
    @unique_block =<<UNIQUE_BLOCK
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
    @homonym_block =<<HOMONYM_BLOCK
def foo
  "still unique"
end

def foo
  "something unique"
end

HOMONYM_BLOCK
  end
  it "scans a directory, returning a list of files" do
    files("spec/test_data").sort.should == ["spec/test_data/first_file.rb",
                                            "spec/test_data/second_file.rb"]
  end
  it "identifies duplication" do
    duplication?("spec/test_data").should be_true
    duplication?("spec/classes_modules").should be_true
  end
  it "returns no false positives when identifying duplication" do
    duplication?("spec/non_duplicating_data").should be_false
  end
  it "extracts :defn nodes" do
    load("spec/test_data")
    def_nodes.should == @the_nodes
    load("spec/classes_modules")
    def_nodes.should == @the_nodes
  end
  it "isolates duplicated blocks" do
    duplicated("spec/test_data").should == @duplicated_block
    duplicated("spec/classes_modules").should == @duplicated_block
  end
  it "reports unique code" do
    unique("spec/test_data").should == @unique_block
    unique("spec/classes_modules").should == @unique_block
  end
  it "reports distinct methods with the same name" do
    homonyms("spec/test_data").should == @homonym_block
    homonyms("spec/classes_modules").should == @homonym_block
  end
  it "reports methods which differ only by one node" do
    pending
  end
  it "reports metadata" do
    pending
  end
  it "gets me a sandwich" do
    pending
  end
end
