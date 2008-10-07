class View
  R2R = Ruby2Ruby.new
  def to_ruby(nodes)
    R2R.process(nodes) + "\n"
  end
  def render(options = {})
    ERB.new(File.read("#{File.dirname(__FILE__) + "/" + options[:template]}"), nil, "-").result(binding)
  end
end
