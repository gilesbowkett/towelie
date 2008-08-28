require 'test/unit'
require 'towelie'

module DummyValues
  def dummy_counted_hash
    {
     "asdf" => [Line.new("asdf", "asdf", nil),
                Line.new("asdf", "asdf", nil),
                Line.new("asdf", "asdf", nil),
                Line.new("asdf", "asdf", nil)],
     "muppets" => [Line.new("muppets", "muppets", nil),
                   Line.new("muppets", "muppets", nil)],
     "qwerty" => [Line.new("qwerty", "qwerty", nil),
                  Line.new("qwerty", "qwerty", nil),
                  Line.new("qwerty", "qwerty", nil)]
    }
  end
  def dummy_lines_report
    [[Line.new("asdf", "asdf", nil),
      Line.new("asdf", "asdf", nil),
      Line.new("asdf", "asdf", nil),
      Line.new("asdf", "asdf", nil)]]
  end
end

class TestTowelie < Test::Unit::TestCase
  include DummyValues
  def test_hash_most_counted
    assert_equal dummy_counted_hash.most_counted, ["asdf", "qwerty", "muppets"]
  end
  def test_report_lines_more_frequently_recurring
    assert_equal dummy_counted_hash.report_lines_more_frequently_recurring_than(3), dummy_lines_report
  end
end

class TestIdea < Test::Unit::TestCase
  def test_obvious
    23.times {puts "the problem with this system is the total lack of data types. need OBJEX"}
  end
end
