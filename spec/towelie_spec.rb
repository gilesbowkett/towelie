require 'lib/array'
require 'lib/towelie'

describe Towelie do
  before(:each) do
    @towelie = Towelie.new
  end
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
    @two_node_diff_block =<<TWO_NODE_DIFF_BLOCK
def bar
  puts("muppetfuckers")
  @variable = "bar"
end

def foo
  puts("muppetphuckers")
  @variable = "foo"
end

TWO_NODE_DIFF_BLOCK
  end
  it "identifies duplication" do
    @towelie.duplication?("spec/test_data").should be_true
    @towelie.duplication?("spec/classes_modules").should be_true
  end
  it "returns no false positives when identifying duplication" do
    @towelie.duplication?("spec/non_duplicating_data").should be_false
  end
  it "extracts :defn nodes" do
    @towelie.dir = "spec/test_data"
    @towelie.method_definitions.should == @the_nodes
    @towelie.parse("spec/classes_modules")
    @towelie.method_definitions.should == @the_nodes
  end
  it "isolates duplicated blocks" do
    @towelie.duplicated("spec/test_data").should == @duplicated_block
    @towelie.duplicated("spec/classes_modules").should == @duplicated_block
  end
  it "reports unique code" do
    @towelie.unique("spec/test_data").should == @unique_block
    @towelie.unique("spec/classes_modules").should == @unique_block
  end
  it "reports distinct methods with the same name" do
    @towelie.homonyms("spec/test_data").should == @homonym_block
    @towelie.homonyms("spec/classes_modules").should == @homonym_block
  end
  it "reports methods which differ only by one node" do
    @towelie.parse("spec/one_node_diff")
    @towelie.diff(1).should == @one_node_diff_block
    @towelie.parse("spec/larger_one_node_diff")
    @towelie.diff(1).should == @bigger_one_node_diff_block
  end
  it "reports methods which differ by arbitrary numbers of nodes" do
    @towelie.parse("spec/two_node_diff")
    @towelie.method_definitions.should_not be_empty
    @towelie.diff(2).should == @two_node_diff_block
  end
  it "attaches filenames to individual nodes" do
    @towelie.parse("spec/two_node_diff")
    @towelie.method_definitions[0].filename.should == "spec/two_node_diff/second_file.rb"
  end
end
