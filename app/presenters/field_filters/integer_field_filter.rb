module FieldFilters
  class IntegerFieldFilter < Filter
    def max_machine_name
      "#{machine_name}_max".to_sym
    end

    def min_machine_name
      "#{machine_name}_min".to_sym
    end

    def min
      field.minimum
    end

    def max
      field.maximum
    end

    def suffix
      field.suffix
    end
  end
end