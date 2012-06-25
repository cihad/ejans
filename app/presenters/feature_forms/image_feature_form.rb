module FeatureForms
  class ImageFeatureForm < FeatureForm
    def value
      feature_configuration.value_name.to_sym
    end
  end
end