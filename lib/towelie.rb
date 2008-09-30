require 'find'
require 'rubygems'
require 'parse_tree'
require 'ruby2ruby'

require "#{File.dirname(__FILE__) + "/"}code_base"
require "#{File.dirname(__FILE__) + "/"}node_analysis"
require "#{File.dirname(__FILE__) + "/"}view"

module Towelie
  include CodeBase
  include NodeAnalysis
  include View
end

# most methods need a dir loaded. therefore we should have an object which takes a dir (and probably
# loads it) on init. also a new Ruby2Ruby might belong in the initializer, who knows.

# ironically, Towelie itself is very not-DRY. lots of "parse dir".

# one thing I've been doing consistently is parsing the dir and collecting the method definitions.
# further, everything here assumes that this has happened. therefore! I think A) I should write some
# code which *ensures* it always happens and B) I think I should incorporate method definition
# collecting into the process where I loop through filenames. the reason, of course, is that it
# allows me to trivially collect filenames in the process, and thereby obtain at least the most
# basic metadata.
