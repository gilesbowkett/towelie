class View
  def initialize(template_name)
    @template_name = template_name
  end
  def to_ruby(nodes)
    nodes.inject("") do |string, node|
      string += Ruby2Ruby.new.process(node) + "\n\n"
    end
  end
  def render(nodes)
    ERB.new(File.read("#{File.dirname(__FILE__) + "/" + @template_name}")).result(binding)
  end
end
