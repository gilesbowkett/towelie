class Model
  module NodeAnalysis
    def duplication?
      not duplicates.empty?
    end
    def duplicates
      (@method_definitions.collect do |node|
        node if @method_definitions.duplicates? node
      end).compact
    end
    def unique
      @method_definitions - duplicates
    end
    def homonyms
      @method_definitions.comparing_collect do |method_definition_1, method_definition_2|
        method_definition_1.name == method_definition_2.name
      end
    end
    def diff(threshold)
      @method_definitions.comparing_collect do |method_definition_1, method_definition_2|
        next if method_definition_1.flatten.size < method_definition_2.flatten.size
        threshold >= (method_definition_1.body.flatten - method_definition_2.body.flatten).size
      end
    end
  end
end
