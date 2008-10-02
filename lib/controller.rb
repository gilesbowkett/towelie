class Towelie
  class << self
    def delegate_thru_view(*method_names)
      method_names.each do |method_name|
        class_eval <<-METHOD
        def #{method_name}(*args)
          @view.render(@model.#{method_name}(*args))
        end
        METHOD
      end
    end
    def delegate_thru_model(*method_names)
      method_names.each do |method_name|
        class_eval <<-METHOD
        def #{method_name}(*args)
          @model.#{method_name} *args
        end
        METHOD
      end
    end
  end
end
