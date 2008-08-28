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

            @lines_per_code_fragment.count(stripped, current)
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

  def rank_repeated_lines
    # I should switch this to use inject() - bad habit!
    t3h_ha5h = {}
    @lines_per_code_fragment.report_lines_more_frequently_recurring_than(200).each do |lines|
      t3h_ha5h[lines[0].stripped] = lines
    end
    t3h_ha5h.most_counted.each {|frequently_counted| puts t3h_ha5h[frequently_counted].size}
  end
end

