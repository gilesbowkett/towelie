class MuppetBalls < Wtf
  def recent
    find(:all)
  end
  def dropdown
    find(:all).collect { |u| [u.name, u.name] }
  end
end
