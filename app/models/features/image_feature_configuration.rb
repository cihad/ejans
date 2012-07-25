module Features
  class ImageFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document

    field :maximum_image, type: Integer

    def build_assoc!(node)
      Features::ImageFeature.set_key(key_name)
      if node.features.map(&:feature_configuration).include?(self)
        feature = node.features.where(feature_configuration_id: self.id.to_s).first
      else
        feature = node.features.build({}, Features::ImageFeature)
        feature.feature_configuration = self
      end
    end
  end
end