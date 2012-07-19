module Features
  class ImageFeature
    include Mongoid::Document
    # parent, configuration, child_configuration, required?
    include Ejans::Features::FeatureAbility

    # Associations
    embedded_in :feature, class_name: "Features::Feature"

    # Validates
    validate :maximum_image

    def value
      send(parent.feature_configuration.value_name)
    end

    def self.add_value(name)
      has_and_belongs_to_many :"#{name}",
        class_name: "Features::Image"
    end

    private
    def maximum_image
      if send(configuration.value_name).size > child_configuration.maximum_image
        add_error("Maximum image")
      end
    end
  end
end