module FeatureForms
  class TagFeatureForm < FeatureForm
    def form_key
      :"#{key_name}_tags"
    end
  end
end