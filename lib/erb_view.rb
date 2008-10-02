class ErbView < View
  def render(nodes)
    body = to_ruby(nodes.body)
    name = nodes.name
    filename = nodes.filename
  end
end
