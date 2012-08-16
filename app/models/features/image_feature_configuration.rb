module Features
  class ImageFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document
    field :maximum_image, type: Integer

    def build_assoc!(node)
      super
      @feature.save(validate: false)
    end
  end
end