module Features
  class StringFeature
    include Mongoid::Document
    embedded_in :feature, class_name: "Features::Feature"
    
    def self.add_value(name)
      field :"#{name}", type: String
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

    def max
      type_configuration.maximum_length
    end

    def min
      type_configuration.minumum_length
    end

    validate :presence_value
    validate :not_greater_than_maximum_length
    validate :not_less_than_minumum_length

    private
    def presence_value
      if required? and value.blank?
        errors.add(:base, "Not should cihaaaaaddd!!")
      end
    end

    def not_less_than_minumum_length
      if min and value.size < min
        errors.add(:base, "asfdasd")
      end
    end

    def not_greater_than_maximum_length
      if max and value.size > max
        errors.add(:base, "asfdasd")
      end
    end
  end
end