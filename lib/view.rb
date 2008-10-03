class View
  def initialize(template_name)
    @template_name = template_name
  end
  def to_ruby(nodes)
    Ruby2Ruby.new.process(nodes) + "\n"
  end
  def render(nodes)
    ERB.new(File.read("#{File.dirname(__FILE__) + "/" + @template_name}")).result(binding)
  end
end
