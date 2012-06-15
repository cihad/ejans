module FeatureForms
  class StringFeatureForm < FeatureForm
    def value
      feature_configuration.value_name.to_sym
    end

    def text_field?
      child.row == 1 ? true : false
    end

    def row
      child.row
    end

    def max
      child.maximum_length
    end

    def min
      child.minumum_length
    end

    def default_value
      child.default_value
    end
  end
end