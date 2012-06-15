module Features
  class ListFeature
    include Mongoid::Document
    include Ejans::Features::FeatureAbility
    include Ejans::Features::MultipleValueFeature

    embedded_in :feature, class_name: "Features::Feature"
    has_and_belongs_to_many :list_items, class_name: "Features::ListItem", inverse_of: nil

    def max
      type_configuration.maximum_select
    end

    validate :presence_value

    private
    def presence_value
      if required? and value.blank?
        errors.add(:base, "Not should cihaaaaaddd!!")
      end
    end
  end
end