require 'find'
require 'rubygems'
require 'parse_tree'
require 'ruby2ruby'

module Towelie
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
    @translations = files(dir).inject({}) do |hash, filename|
      hash[filename] = ParseTree.translate File.read(filename)
      hash
    end
  end
  def def_nodes
    accumulator = []
    _find_def_nodes(accumulator, @translations)
  end
  def _find_def_nodes(accumulator, nodes)
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
          _find_def_nodes(accumulator, node)
        end
      end
    end
    accumulator
  end
  def duplication?(dir)
    parse dir
    def_nodes.uniq != def_nodes
  end
  def duplicated(dir)
    parse dir
    to_ruby(duplicates)
  end
  def duplicates
    (def_nodes.collect do |node|
      node if def_nodes.duplicates? node
    end).compact.uniq
  end
  def unique(dir)
    parse dir
    to_ruby(def_nodes - duplicates)
  end
  def homonyms(dir)
    parse dir
    homonyms = []
    def_nodes.stepwise do |def_node_1, def_node_2|
      homonyms << def_node_1 if def_node_1.name == def_node_2.name
    end
    to_ruby(homonyms)
  end
  def one_node_diff(dir)
    parse dir
    one_nodes = {}
    def_nodes.stepwise do |def_node_1, def_node_2|
      one_nodes[def_node_1.name] = def_node_1 if 1 == (def_node_1.body - def_node_2.body).size
    end
    to_ruby(one_nodes.values)
  end
  def to_ruby(nodes)
    nodes.inject("") do |string, node|
      string += Ruby2Ruby.new.process(node) + "\n\n"
    end
  end
end

# most methods need a dir loaded. therefore we should have an object which takes a dir (and probably
# loads it) on init. also a new Ruby2Ruby might belong in the initializer, who knows.

# when I switch to objects, it'll be much prettier to parameterize one_node_diff to a general
# "def diff(threshold)" style.
