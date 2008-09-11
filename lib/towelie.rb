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
    @duplicate_lines = []

    files(dir).each do |filename|

      duplicating = false
      dup_buffer = []

      File.open(filename, "r") do |file|
        file.each_line do |line|
          if @all_lines.include? line
            duplicating = true
            dup_buffer << line
          else
            puts line
            @all_lines << line

            if duplicating && dup_buffer.size > 1
              dup_buffer.each {|dup| @duplicate_lines << dup}
            end
            dup_buffer = []
            duplicating = false
          end
        end
      end
    end
  end
  def duplication?(dir)
    load dir
    not @duplicate_lines.empty?
  end
  def duplicated(dir)
    load dir
    @duplicate_lines
  end
end

# every method needs a dir. therefore we should have an object which takes a dir (and probably
# loads it) on init.
