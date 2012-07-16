module Features
  class PlaceFeature
    include Mongoid::Document
    # parent, configuration, child_configuration, required?
    include Ejans::Features::FeatureAbility
    include Ejans::Features::SingleValueFeature

    # Associations
    embedded_in :feature, class_name: "Features::Feature"

    # Validates
    validate :presence_value

    # Singleton Methods
    def self.add_value(name)
      has_and_belongs_to_many :"#{name}", class_name: "Place", inverse_of: nil
    end

    private
    def presence_value
      if required? and value.blank?
        errors.add(:base, "Not should cihaaaaaddd!!")
      end
    end
  end
end