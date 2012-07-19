module FeatureForms
  class ImageFeatureForm < FeatureForm
    def value
      feature_configuration.value_name.to_sym
    end

    def maximum_image
      child.maximum_image
    end
  end
end