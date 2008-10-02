class ErbView < View
  def render(nodes)
    ERB.new(File.read("#{File.dirname(__FILE__) + "/"}view.erb")).result(binding)
  end
end
