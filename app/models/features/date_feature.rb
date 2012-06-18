module Features
  class DateFeature
    include Mongoid::Document
    include Mongoid::MultiParameterAttributes
    include Ejans::Features::FeatureAbility
    include Ejans::Features::SingleValueFeature

    # Associations
    embedded_in :feature, class_name: "Features::Feature"

    # Validates
    validate :presence_value

    # Singleton Methods
    def self.add_value(name)
      field :"#{name}", type: Date
    end

    private
    def presence_value
      if required? and value.blank?
        errors.add(:base, "Not should cihaaaaaddd!!")
      end
    end    
  end
end