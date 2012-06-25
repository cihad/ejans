module Features
  class IntegerFeature
    include Mongoid::Document
    # parent, configuration, child_configuration, required?
    include Ejans::Features::FeatureAbility
    include Ejans::Features::SingleValueFeature

    # Associations
    embedded_in :feature, class_name: "Features::Feature"

    # Validates
    validate :presence_value
    validate :not_greater_than_maximum
    validate :not_less_than_minumum

    # Singleton Methods
    def self.add_value(name)
      field :"#{name}", type: Integer
    end

    def min
      child_configuration.minumum
    end

    def max
      child_configuration.maximum
    end

    private
    def presence_value
      if required? and value.blank?
        errors.add(:base, "Not should cihaaaaaddd!!")
      end
    end

    def not_greater_than_maximum
      if value.present? and max and value > max
        errors.add(:base)
      end
    end

    def not_less_than_minumum
      if value.present? and min and value < min
        errors.add(:base)
      end
    end    
  end
end