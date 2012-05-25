module FeatureForms
  class IntegerFeatureForm < FeatureForm
    def value
      feature_configuration.value_name.to_sym
    end
    
    def maximum
      configuration_object.maximum
    end

    def minumum
      configuration_object.minumum
    end

    def filter?
      configuration_object.filter?
    end

    def filter_type
      configuration_object.filter_type
    end

  end
end