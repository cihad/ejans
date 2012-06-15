module FeatureForms
  class IntegerFeatureForm < FeatureForm
    def value
      feature_configuration.value_name.to_sym
    end
    
    def maximum
      child.maximum
    end

    def minumum
      child.minumum
    end

    def filter?
      child.filter?
    end

    def filter_type
      child.filter_type
    end

  end
end