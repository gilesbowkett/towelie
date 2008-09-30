module Towelie
  module CodeBase
    def files(dir)
      # Find supplies no #inject
      accumulator = []
      Find.find(dir) do |filename|
        next if File.directory? filename or filename =~ /.*\.(git|svn).*/
        accumulator << filename
      end
      accumulator
    end
    def parse(dir)
      @nodes = files(dir).inject([]) do |array, filename|
        array << (ParseTree.translate File.read(filename)) ; array
      end
    end
    def method_definitions(accumulator = [], nodes = @nodes)
      nodes.each do |node|
        case node
        when Array
          if node[0] == :defn
            accumulator << node
            class << node
              def name
                self[1]
              end
              def body
                self[2]
              end
            end
          else
            method_definitions(accumulator, node)
          end
        end
      end
      accumulator
    end
  end
end
