module FeatureForms
  class ListFeatureForm < FeatureForm
    def value
      :"#{feature_configuration.value_name}_ids"
    end
  end
end