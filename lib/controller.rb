class Towelie  
  class << self
    def delegate_thru_view(*method_names)
      method_names.each do |method_name|
        class_eval <<-METHOD
        def #{method_name}(*args)
          @view.to_ruby(@model.#{method_name}(*args))
        end
        METHOD
      end
    end
    def delegate_thru_model(*method_names)
      method_names.each do |method_name|
        class_eval <<-METHOD
        def #{method_name}(*args)
          @model.#{method_name}(*args)
        end
        METHOD
      end
    end
  end
  delegate_thru_model :parse, :duplication?, :method_definitions
  delegate_thru_view :duplicated, :unique, :homonyms, :diff
end
