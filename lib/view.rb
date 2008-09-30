module Towelie
  module View
    def to_ruby(nodes)
      nodes.inject("") do |string, node|
        string += Ruby2Ruby.new.process(node) + "\n\n"
      end
    end
  end
end
