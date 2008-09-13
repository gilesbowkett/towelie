require 'lib/array'
require 'lib/towelie'
include Towelie

# this is a subset of towelie_spec.rb which verifies functionality in that spec also works within
# classes and modules.

describe Towelie do
  it "identifies duplication" do
    duplication?("spec/classes_modules").should be_true
  end
  it "extracts :defn nodes" do
    load("spec/classes_modules")
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
    duplicated("spec/classes_modules").should == duplicated_block
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
    unique("spec/classes_modules").should == unique_block
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
    homonyms("spec/classes_modules").should == homonym_block
  end
end
