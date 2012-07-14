module Features
  class StringFeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility

    TEXT_FORMATS = [:plain, :simple, :extended]
    
    # Fields
    field :row, type: Integer, default: 1
    field :minumum_length, type: Integer
    field :maximum_length, type: Integer
    field :text_format, type: Symbol

    validates :text_format, inclusion: { in: TEXT_FORMATS }

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