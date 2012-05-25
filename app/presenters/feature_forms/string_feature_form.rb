module FeatureForms
  class StringFeatureForm < FeatureForm
    def value
      feature_configuration.value_name.to_sym
    end

    def text_field?
      configuration_object.row == 1 ? true : false
    end

    def row
      configuration_object.row
    end

    def max
      configuration_object.maximum_length
    end

    def min
      configuration_object.minumum_length
    end

    def default_value
      configuration_object.default_value
    end
  end
end