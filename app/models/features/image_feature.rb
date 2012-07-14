module Features
  class ImageFeature
    include Mongoid::Document
    # parent, configuration, child_configuration, required?
    include Ejans::Features::FeatureAbility

    # Associations
    embedded_in :feature, class_name: "Features::Feature"

    # Validates
    # validate :presence_value

    def value
      send(parent.feature_configuration.value_name)
    end

    # Singleton Methods
    def self.add_value(name)
      has_and_belongs_to_many :"#{name}", class_name: "Features::Image"
    end

    private
    def presence_value
      if required? and value.blank?
        errors.add(:base, "Not should cihaaaaaddd!!")
      end
    end
  end
end