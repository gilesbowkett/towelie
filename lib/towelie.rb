require 'find'
require 'rubygems'
require 'parse_tree'
require 'ruby2ruby'

module Towelie
  
  # model
  
  def files(dir)
    # Find supplies no #inject
    accumulator = []
    Find.find(dir) do |filename|
      next if File.directory? filename or filename =~ /.*\.(git|svn).*/
      accumulator << filename
    end
    accumulator
  end
  def parse(dir)
    @nodes = files(dir).inject([]) do |array, filename|
      array << (ParseTree.translate File.read(filename)) ; array
    end
  end
  def method_definitions(accumulator = [], nodes = @nodes)
    nodes.each do |node|
      case node
      when Array
        if node[0] == :defn
          accumulator << node
          class << node
            def name
              self[1]
            end
            def body
              self[2]
            end
          end
        else
          method_definitions(accumulator, node)
        end
      end
    end
    accumulator
  end
  
  # controller
  
  def duplication?(dir)
    parse dir
    not duplicates.empty?
  end
  def duplicated(dir)
    parse dir
    duplicates
  end
  def duplicates
    (method_definitions.collect do |node|
      node if method_definitions.duplicates? node
    end).compact.uniq
  end
  def unique(dir)
    parse dir
    method_definitions - duplicates
  end
  def homonyms(dir)
    parse dir
    homonyms = []
    method_definitions.stepwise do |method_definition_1, method_definition_2|
      homonyms << method_definition_1 if method_definition_1.name == method_definition_2.name
    end
    homonyms
  end
  def diff(threshold)
    diff_nodes = {}
    method_definitions.stepwise do |method_definition_1, method_definition_2|
      if threshold >= (method_definition_1.body - method_definition_2.body).size
        diff_nodes[method_definition_1.name] = method_definition_1
        # note this hash approach fails to record multiple one-node-diff methods with the same name
      end
    end
    diff_nodes.values
  end
  
  # view
  
  def to_ruby(nodes)
    nodes.inject("") do |string, node|
      string += Ruby2Ruby.new.process(node) + "\n\n"
    end
  end
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
