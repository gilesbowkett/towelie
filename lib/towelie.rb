require 'find'
require 'rubygems'
require 'parse_tree'
require 'ruby2ruby'

require "#{File.dirname(__FILE__) + "/"}array"

require "#{File.dirname(__FILE__) + "/"}code_base"
require "#{File.dirname(__FILE__) + "/"}node_analysis"
require "#{File.dirname(__FILE__) + "/"}model"
require "#{File.dirname(__FILE__) + "/"}view"


class Towelie
  def initialize
    @model = Model.new
    @view = View.new
  end
  def parse(dir)
    @model.parse(dir)
  end
  alias :dir= :parse
  def duplication?(dir)
    @model.duplication?(dir)
  end
  def method_definitions
    @model.method_definitions
  end
  def duplicated(dir)
    @view.to_ruby(@model.duplicated(dir))
  end
  def unique(dir)
    @view.to_ruby(@model.unique(dir))
  end
  def homonyms(dir)
    @view.to_ruby(@model.homonyms(dir))
  end
  def diff(threshold)
    @view.to_ruby(@model.diff(threshold))
  end
end

# most methods need a dir loaded. therefore we should have an object which takes a dir (and probably
# loads it) on init. also a new Ruby2Ruby might belong in the initializer, who knows.

# ironically, Towelie itself is very not-DRY. lots of "parse dir".

# one thing I've been doing consistently is parsing the dir and collecting the method definitions.
# further, everything here assumes that this has happened. therefore! I think I should write some
# code which *ensures* it always happens.
