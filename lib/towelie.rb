require 'find'

module Towelie
  def files(dir)
    accumulator = []
    Find.find(dir) do |filename|
      next if File.directory? filename
      accumulator << filename
    end
    accumulator
  end
  def duplication?(dir)
    files(dir) do |filename|
      next if filename =~ /\.git/
      # if filename =~ /.+\.e?rb$/
        File.open(filename, "r") do |file|
          # previous = current = nil
          file.each_line do |line|
            # next if skip?(line)
            stripped = line.gsub(/\s/, "")

            current = Line.new(line, stripped, previous)
            @all_lines << current
            previous = current
          end
        end
      # end
    end
  end
end
