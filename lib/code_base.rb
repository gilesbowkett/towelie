class Model
  module CodeBase
    def parse(dir)
      @method_definitions = []
      Find.find(dir) do |filename|
        next if File.directory? filename or filename =~ /.*\.(git|svn).*/
        extract_definitions(@method_definitions, (ParseTree.translate File.read(filename)), filename)
      end
    end
    def extract_definitions(accumulator, nodes, filename)
      case nodes
      when Array
        if nodes[0] == :defn
          accumulator << nodes
          nodes.instance_eval <<-ACCESSORS
            def name
              self[1]
            end
            def body
              self[2]
            end
            def filename
              "#{filename}"
            end
          ACCESSORS
        else
          nodes.each {|node| extract_definitions(accumulator, node, filename)}
        end
      end
      accumulator
    end
  end
end
