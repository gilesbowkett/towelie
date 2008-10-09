class Array
  def duplicates?(element)
    grep(element).size > 1 
  end
  def stepwise
    self.each do |element1|
      self.each do |element2|
        next if element1 == element2
        yield element1, element2
      end
    end
  end
  def comparing_collect
    accumulator = [] # collect implementation copied from Rubinius
    stepwise do |element1, element2|
      accumulator << element1 if yield(element1, element2)
    end
    accumulator.compact.uniq
  end
end
