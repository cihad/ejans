module Features
  class DateFeature
    include Mongoid::Document
    include Mongoid::MultiParameterAttributes
    include Ejans::Features::FeatureAbility

    # Associations
    embedded_in :feature, class_name: "Features::Feature"

    # Validates
    validate :presence_value
    validate :start_and_end_date

    # Singleton Methods
    def self.add_value(name)
      field :"#{name}", type: Date
    end

    private
    def presence_value
      if required? and not_defined?
        add_error(value_name)
      end
    end

    def start_and_end_date
      if value.year < child_configuration.start_year or
         value.year > child_configuration.end_year
        add_error(value_name)
      end
    end

    def not_defined?
      value == Date.new(1) || value.blank?
    end
  end
end