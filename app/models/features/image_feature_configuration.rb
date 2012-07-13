module Features
  class ImageFeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility
    include Ejans::Features::SingleValueFeatureConfiguration

    # Fields
    field :maximum_image, type: Integer
    
    # Associations
    embedded_in :feature_configuration, class_name: "Features::FeatureConfiguration"

    def build_assoc!(node)
      if node.features.map(&:feature_configuration).include?(parent)
        feature = node.features.where(feature_configuration_id: parent.id.to_s).first
      else
        feature = node.features.build
        feature.feature_configuration = parent
        feature.send("build_#{feature_type}")
      end

      feature.child.class.add_value(value_name)
    end

    # Object Methods
    def type
      "Image"
    end

    def filterable?
      false
    end
  end
end