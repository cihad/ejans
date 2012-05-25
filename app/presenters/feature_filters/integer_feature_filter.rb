module FeatureFilters
  class IntegerFeatureFilter < Filter
    def max_machine_name
      "#{machine_name}_max".to_sym
    end

    def min_machine_name
      "#{machine_name}_min".to_sym
    end

    def machine_name
      feature_configuration.machine_name.to_sym
    end
  end
end