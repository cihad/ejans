module Features
  class ImageFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document
    field :maximum_image, type: Integer
  end
end