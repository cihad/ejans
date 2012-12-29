module FieldFilters
  class IntegerFieldFilter < Filter

    delegate :minimum, :maximum, :suffix, to: :field
    alias :min :minimum
    alias :max :maximum

    def max_machine_name
      "#{machine_name}_max".to_sym
    end

    def min_machine_name
      "#{machine_name}_min".to_sym
    end

  end
end