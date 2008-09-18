require 'lib/array'

describe Array do
  it "identifies duplicate elements" do
    ([1,1,2].duplicates? 4).should be_false
    ([1,1,2].duplicates? 2).should be_false
    ([1,1,2].duplicates? 1).should be_true

    ([].duplicates? 1).should be_false
  end
end
