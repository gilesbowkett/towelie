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
    @one_node_diff_block =<<ONE_NODE_DIFF_BLOCK
def bar
  "bar"
end

def foo
  "foo"
end

ONE_NODE_DIFF_BLOCK
    @bigger_one_node_diff_block =<<BIGGER_ONE_NODE_DIFF_BLOCK
def bar
  puts("muppetfuckers")
  @variable = "bar"
end

def foo
  puts("muppetfuckers")
  @variable = "foo"
end

BIGGER_ONE_NODE_DIFF_BLOCK
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
    parse("spec/test_data")
    def_nodes.should == @the_nodes
    parse("spec/classes_modules")
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
    one_node_diff("spec/one_node_diff").should == @one_node_diff_block
    one_node_diff("spec/larger_one_node_diff").should == @bigger_one_node_diff_block
  end
end
