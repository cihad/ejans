module FeatureForms
  class ImageFeatureForm < FeatureForm
    def maximum_image
      conf.maximum_image
    end

    def images
      feature.value
    end
  end
end