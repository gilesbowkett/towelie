require 'find'
require 'rubygems'
require 'parse_tree'
require 'ruby2ruby'

module Towelie
  def files(dir)
    accumulator = []
    Find.find(dir) do |filename|
      next if File.directory? filename || filename =~ /\.git/
      accumulator << filename
    end
    accumulator
  end
  def load(dir)
    @translations = {}
    files(dir).each do |filename|
      @translations[filename] = ParseTree.translate File.read(filename)
    end
  end
  def duplication?(dir)
    load dir
    def_nodes = @translations.values.collect do |translation|
      translation.collect do |node|
        node if node.is_a? Array and node[0] == :defn
      end
    end
    def_nodes.compact!
    def_nodes.uniq == def_nodes
  end
  def duplicated(dir)
    load dir
    nil
  end
end

# every method needs a dir. therefore we should have an object which takes a dir (and probably
# loads it) on init.
