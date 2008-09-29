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
    duplicated = (def_nodes.collect {|element| element if def_nodes.duplicates? element}).compact
    to_ruby(def_nodes - duplicated)
  end
  def homonyms(dir)
    parse dir
    homonyms = []
    def_nodes.each do |element1|
      def_nodes.each do |element2|
        next if element1 == element2
        homonyms << element1 if element1[1] == element2[1]
          # def_node[1] is def_node's name.
          # these should probably be objects.
      end
    end
    to_ruby(homonyms)
  end
  def one_node_diff(dir)
    parse dir
    one_nodes = {}
    def_nodes.each do |def_node_1|
      def_nodes.each do |def_node_2|
        next if def_node_1 == def_node_2
        one_nodes[def_node_1[1]] = def_node_1 if 1 == (def_node_1[2] - def_node_2[2]).size
          # def_node[1] is def_node's name.
          # these should probably be objects.
          
          # note also that this means when you have more than one one-node-diff method
          # with the same name, the last such method analyzed is the one that goes in
          # the hash. fail!
      end
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

# might also be worth it to move some of these set operations out into Enumerable.
