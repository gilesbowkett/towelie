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
    # this might be something I could turn into a #collect
    @translations = {}
    files(dir).each do |filename|
      @translations[filename] = ParseTree.translate File.read(filename)
    end
  end
  def def_nodes
    # this is #collect, but with an additional level of nesting
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
    Ruby2Ruby.new.process(duplicates[0]) + "\n"
  end
  def duplicates
    (def_nodes.collect do |node|
      node if def_nodes.duplicates? node
    end).compact.uniq
  end
end

# every method needs a dir. therefore we should have an object which takes a dir (and probably
# loads it) on init. also a new Ruby2Ruby might belong in the initializer, who knows.
