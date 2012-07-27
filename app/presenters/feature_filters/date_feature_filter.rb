module FeatureFilters
  class DateFeatureFilter < Filter
    def start_machine_name
      "#{machine_name}_start".to_sym
    end

    def end_machine_name
      "#{machine_name}_end".to_sym
    end
  end
end