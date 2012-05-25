module Features
  class IntegerFeature
    include Mongoid::Document
    embedded_in :feature, class_name: "Features::Feature"

    validate :presence_value
    validate :not_greater_than_maximum
    validate :not_less_than_minumum

    def self.add_value(name)
      field :"#{name}", type: Integer
    end

    def value
      self.send(configuration.value_name)
    end

    def configuration
      feature.feature_configuration
    end

    def type_configuration
      configuration.configuration_object
    end

    def required?
      configuration.required?
    end

    def min
      type_configuration.minumum
    end

    def max
      type_configuration.maximum
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