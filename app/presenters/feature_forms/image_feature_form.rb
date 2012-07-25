module FeatureForms
  class ImageFeatureForm < FeatureForm
    def value
      conf.key_name
    end

    def maximum_image
      conf.maximum_image
    end
  end
end