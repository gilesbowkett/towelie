module Towelie
  module NodeAnalysis
    def duplication?(dir)
      parse dir
      not duplicates.empty?
    end
    def duplicated(dir)
      parse dir
      duplicates
    end
    def duplicates
      (method_definitions.collect do |node|
        node if method_definitions.duplicates? node
      end).compact.uniq
    end
    def unique(dir)
      parse dir
      method_definitions - duplicates
    end
    def homonyms(dir)
      parse dir
      homonyms = []
      # this picks up duplicates as well as homonyms, since a duplicate is technically also a homonym,
      # and I should probably run .uniq on it also.
      method_definitions.stepwise do |method_definition_1, method_definition_2|
        homonyms << method_definition_1 if method_definition_1.name == method_definition_2.name
      end
      homonyms
    end
    def diff(threshold)
      diff_nodes = []
      method_definitions.stepwise do |method_definition_1, method_definition_2|
        if threshold >= (method_definition_1.body - method_definition_2.body).size
          diff_nodes << method_definition_1
          # note this hash approach fails to record multiple one-node-diff methods with the same name
        end
      end
      diff_nodes
    end
  end
end
