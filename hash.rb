class Hash
  def report_lines_more_frequently_recurring_than(limit)
    (collect do |code_fragment, lines|
      lines if lines.size > limit
    end).compact
  end
  def count(key, value)
    if has_key? key
      self[key] << value
    else
      self[key] = [value]
    end
  end
  def most_counted
    (sort_by do |a,b|
      a[1] ||= [] ; b[1] ||= []
      a[1].size <=> b[1].size
    end).collect {|array| array[0]}
  end
end

