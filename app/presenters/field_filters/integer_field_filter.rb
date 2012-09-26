module FieldFilters
  class IntegerFieldFilter < Filter
    def max_machine_name
      "#{machine_name}_max".to_sym
    end

    def min_machine_name
      "#{machine_name}_min".to_sym
    end

    def min
      conf.minimum
    end

    def max
      conf.maximum
    end
  end
end