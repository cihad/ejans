module Features
  class ListFeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility
    include Ejans::Features::MultipleValueFeatureConfiguration

    # Fields
    field :maximum_select, type: Integer

    # Associations
    has_many :list_items, class_name: "Features::ListItem", autosave: true
    accepts_nested_attributes_for :list_items,
      reject_if: ->(attrs){ attrs[:name].blank? }


    embedded_in :feature_view
    belongs_to :feature_configuration, class_name: "Features::FeatureConfiguration"

    # Class Methods
    class << self
    end

    # Object Methods
    def type
      "List"
    end

    def machine_name
      feature_configuration.machine_name
    end

    def filterable?
      true
    end

    def filter_query(params = {})
      if params["#{machine_name}"].present?
        NodeQuery.new.in(:"#{where}" => value).selector
      else
        {}
      end
    end

    private
    def where
      where = "features."
      where += "#{parent_feature_configuration.feature_type}."
      where += "#{parent_feature_configuration.value_name.singularize}_ids"
      where
    end
  end
end