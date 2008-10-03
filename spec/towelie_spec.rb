require 'lib/towelie'

describe Towelie do
  before(:each) do
    @towelie = Towelie.new(:text)
  end
  it "identifies duplication" do
    @towelie.parse("spec/test_data")
    @towelie.duplication?.should be_true

    @towelie.parse("spec/classes_modules")
    @towelie.duplication?.should be_true
  end
  it "returns no false positives when identifying duplication" do
    @towelie.parse("spec/non_duplicating_data")
    @towelie.duplication?.should be_false
  end
end

# I should move this to model spec
