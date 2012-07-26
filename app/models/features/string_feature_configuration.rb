module Features
  class StringFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document

    TEXT_FORMATS = [:plain, :simple, :extended]
    
    # Fields
    field :row, type: Integer, default: 1
    field :minumum_length, type: Integer
    field :maximum_length, type: Integer
    field :text_format, type: Symbol

    validates :text_format, inclusion: { in: TEXT_FORMATS }

    # Methods
    def build_assoc!(node)
      Features::StringFeature.set_key(key_name)
      if node.features.map(&:feature_configuration).include?(self)
        feature = node.features.where(feature_configuration_id: self.id.to_s).first
      else
        feature = node.features.build({}, Features::StringFeature)
        feature.feature_configuration = self
      end
    end
  end
end