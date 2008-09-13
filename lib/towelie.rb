require 'find'
require 'rubygems'
require 'parse_tree'
require 'ruby2ruby'

module Towelie
  def files(dir)
    # Find supplies no #collect
    accumulator = []
    Find.find(dir) do |filename|
      next if File.directory? filename || filename =~ /\.git/
      accumulator << filename
    end
    accumulator
  end
  def load(dir)
    @translations = files(dir).inject({}) do |hash, filename|
      hash[filename] = ParseTree.translate File.read(filename)
      hash
    end
  end
  def def_nodes
    # this is #collect, but with an additional level of nesting. pitfall: the additional level is
    # hard-coded. this means Towelie probably can't handle classes or modules yet.
    accumulator = []
    @translations.values.each do |translation|
      translation.each do |node|
        accumulator << node if node.is_a? Array and node[0] == :defn
      end
    end
    accumulator
  end
  def duplication?(dir)
    load dir
    def_nodes.uniq != def_nodes
  end
  def duplicated(dir)
    load dir
    to_ruby(duplicates)
  end
  def duplicates
    (def_nodes.collect do |node|
      node if def_nodes.duplicates? node
    end).compact.uniq
  end
  def unique(dir)
    load dir
    duplicated = (def_nodes.collect {|element| element if def_nodes.duplicates? element}).compact
    to_ruby(def_nodes - duplicated)
  end
  def homonyms(dir)
    load dir
    homonyms = []
    def_nodes.each do |element1|
      def_nodes.each do |element2|
        next if element1 == element2
        homonyms << element1 if element1[1] == element2[1]
      end
    end
    to_ruby(homonyms)
  end
  def to_ruby(nodes)
    nodes.inject("") do |string, node|
      string += Ruby2Ruby.new.process(node) + "\n\n"
    end
  end
end

# every method needs a dir. therefore we should have an object which takes a dir (and probably
# loads it) on init. also a new Ruby2Ruby might belong in the initializer, who knows.

# might also be worth it to move some of these set operations out into Enumerable.
