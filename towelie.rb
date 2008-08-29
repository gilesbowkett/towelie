require 'line'
require 'hash'

module Towelie
  require 'find'
  def skip?(line)
    line.gsub!(/\s/, "")
    regexes = [/^$/,
               /^end$/,
               /^\#end$/,
               /^\<\%end\%\>$/,
               /^else$/,
               /^\#$/,
               /^\)$/,
               /^\}$/,
               /^\]$/,
               /^\.\,\.\,$/]
    # this should be an injecty thing called confirming
    skip = false
    regexes.each do |regex|
      skip = true if line =~ regex
    end
    skip
  end
  def find(dir = "../")
    @all_lines = []
    @lines_per_code_fragment = {}

    Find.find(dir) do |filename|
      if filename =~ /.+\.e?rb$/
        File.open(filename, "r") do |file|
          next if file =~ /\.git/
          previous = current = nil
          file.each_line do |line|
            next if skip?(line)
            stripped = line.gsub(/\s/, "")

            current = Line.new(line, stripped, previous)
            @all_lines << current
            previous = current
          end
        end
      end
    end
  end

  def report_loc
    squished_lines = @all_lines.collect {|line| line.stripped}
    uniques = squished_lines.uniq

    # this part should use printf but it's too bloody tedious
    puts "total lines of code:    " + squished_lines.size.to_s
    puts "unique lines of code:   " + uniques.size.to_s
    puts "duplicate lines:        " + (squished_lines.size - uniques.size).to_s
  end
  
  def count_repetitions
    counts = {}
    @all_lines.each do |line|
      line = line.stripped
      if counts[line]
        counts[line] += 1
      else
        counts[line] = 1
      end
    end
    counts # need some injecty goodness here I think
  end
  
  def rank_repeated_lines
    highest = 0
    the_line = ""
    count_repetitions.each do |line, count|
      if count > highest
        highest = count
        the_line = line
        puts "#{highest} / #{the_line}"
      end
    end
  end
end

