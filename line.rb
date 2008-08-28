class Line < Struct.new(:original, :stripped, :previous)
  def same_block?(other)
    if self.previous && other.previous
      self.previous.stripped == other.previous.stripped
    else
      false
    end
  end
end

