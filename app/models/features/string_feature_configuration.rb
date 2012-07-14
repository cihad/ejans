module Features
  class StringFeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility
    include Ejans::Features::SingleValueFeatureConfiguration

    FILTER_TYPES = [:plain, :simple, :extended]
    
    # Fields
    field :row, type: Integer, default: 1
    field :maximum_length, type: Integer
    field :minumum_length, type: Integer
    field :default_value, type: String
    field :filter_type, type: Symbol

    # Associations
    embedded_in :feature_configuration, class_name: "Features::FeatureConfiguration"

    # Methods
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
    
    def type
      "String"
    end
    
    def filterable?
      false
    end
  end
end