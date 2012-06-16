module Features
  class ListFeature
    include Mongoid::Document
    include Ejans::Features::FeatureAbility
    include Ejans::Features::MultipleValueFeature

    embedded_in :feature, class_name: "Features::Feature"

    def self.add_value(name)
      has_and_belongs_to_many :"#{name}", class_name: "Features::ListItem"
    end

    def max
      child_configuration.maximum_select
    end

    def value
      send(parent.feature_configuration.value_name).map(&:name).join(', ')
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
