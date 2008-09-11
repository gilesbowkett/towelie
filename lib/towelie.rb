require 'find'

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
    @all_lines = []
    files(dir).each do |filename|
      File.open(filename, "r") do |file|
        file.each_line do |line|
          stripped = line.gsub(/\s/, "")
          @all_lines << stripped
        end
      end
    end
  end
  def duplication?(dir)
    # refactor! this loads data and analyzes it. should be separate steps.
    load dir
    @all_lines.uniq != @all_lines
  end
end
