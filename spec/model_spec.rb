require 'lib/towelie'

describe Towelie do
  before(:each) do
    @model = Model.new
  end
  before(:all) do
    @def_nodes = [
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
    @duplicated_nodes = [
                          [:defn, :bar,
                            [:scope,
                              [:block, [:args], [:str, "something non-unique"]]]],
                          [:defn, :bar,
                            [:scope,
                              [:block, [:args], [:str, "something non-unique"]]]]
                        ]
    @unique_nodes = [
                      [:defn, :foo,
                        [:scope,
                          [:block, [:args], [:str, "still unique"]]]],
                      [:defn, :baz,
                        [:scope,
                          [:block, [:args], [:str, "also unique"]]]],
                      [:defn, :foo,
                        [:scope,
                          [:block, [:args], [:str, "something unique"]]]]
                    ]
    @homonym_nodes = [
                        [:defn, :foo,
                          [:scope,
                            [:block, [:args], [:str, "still unique"]]]],
                        [:defn, :foo,
                          [:scope,
                            [:block, [:args], [:str, "something unique"]]]]
                      ]
    @one_node_diff_nodes = [
                              [:defn, :bar,
                                [:scope,
                                  [:block, [:args], [:str, "bar"]]]],
                              [:defn, :foo,
                                [:scope,
                                  [:block, [:args], [:str, "foo"]]]]
                           ]
    @bigger_one_node_diff_nodes = [
                                      [:defn, :bar,
                                        [:scope,
                                          [:block,
                                           [:args],
                                           [:fcall, :puts,
                                             [:array, [:str, "muppetfuckers"]]],
                                           [:iasgn, :@variable,
                                             [:str, "bar"]]]]],
                                      [:defn, :foo,
                                        [:scope,
                                          [:block,
                                            [:args],
                                            [:fcall, :puts,
                                              [:array, [:str, "muppetfuckers"]]],
                                            [:iasgn, :@variable,
                                              [:str, "foo"]]]]]
                                  ]
    @two_node_diff_nodes = [
                              [:defn, :bar,
                                [:scope,
                                  [:block,
                                   [:args],
                                   [:fcall, :puts,
                                     [:array, [:str, "muppetfuckers"]]],
                                   [:iasgn, :@variable,
                                     [:str, "bar"]]]]],
                              [:defn, :foo,
                                [:scope,
                                  [:block,
                                    [:args],
                                    [:fcall, :puts,
                                      [:array, [:str, "muppetphuckers"]]],
                                    [:iasgn, :@variable,
                                      [:str, "foo"]]]]]
                           ]
  end
  it "identifies duplication" do
    @model.parse("spec/test_data")
    @model.duplication?.should be_true

    @model.parse("spec/classes_modules")
    @model.duplication?.should be_true
  end
  it "returns no false positives when identifying duplication" do
    @model.parse("spec/non_duplicating_data")
    @model.duplication?.should be_false
  end
  it "extracts :defn nodes" do
    @model.parse("spec/test_data")
    @model.method_definitions.should == @def_nodes
    
    @model.parse("spec/classes_modules")
    @model.method_definitions.should == @def_nodes
  end
  it "isolates duplicated blocks" do
    @model.parse("spec/test_data")
    @model.duplicates.should == @duplicated_nodes

    @model.parse("spec/classes_modules")
    @model.duplicates.should == @duplicated_nodes
  end
  it "reports unique code" do
    @model.parse("spec/test_data")
    @model.unique.should == @unique_nodes
  
    @model.parse("spec/classes_modules")
    @model.unique.should == @unique_nodes
  end
  it "reports distinct methods with the same name" do
    @model.parse("spec/test_data")
    @model.homonyms.should == @homonym_nodes
    
    @model.parse("spec/classes_modules")
    @model.homonyms.should == @homonym_nodes
  end
  it "reports methods which differ only by one node" do
    @model.parse("spec/one_node_diff")
    @model.diff(1).should == @one_node_diff_nodes
  
    @model.parse("spec/larger_one_node_diff")
    @model.diff(1).should == @bigger_one_node_diff_nodes
  end
  it "reports methods which differ by arbitrary numbers of nodes" do
    @model.parse("spec/two_node_diff")
    @model.method_definitions.should_not be_empty
    @model.diff(2).should == @two_node_diff_nodes
  end
  it "attaches filenames to individual nodes" do
    @model.parse("spec/two_node_diff")
    @model.method_definitions[0].filename.should == "spec/two_node_diff/second_file.rb"
  end
  it "doesn't return false positives for one-node diffs" do
    @model.parse("spec/diff_false_positives")
    @model.diff(1).should == []
  end
  it "doesn't return false positives for five-node diffs" do
    @model.parse("spec/diff_false_positives")
    @model.diff(5).should == []
  end
end
