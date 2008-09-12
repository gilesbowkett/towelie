class Array
  def duplicates?(element)
    (self.select {|elem| elem == element}).size > 1 
  end 
end
