module Features
  class ListFeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility
    include Ejans::Features::MultipleValueFeatureConfiguration

    # Fields
    field :maximum_select, type: Integer

    # Associations
    has_many :list_items, class_name: "Features::ListItem"
    accepts_nested_attributes_for :list_items,
      reject_if: ->(attrs){ attrs[:name].blank? }

    belongs_to :feature_configuration, class_name: "Features::FeatureConfiguration"

    # Object Methods
    def build_assoc!(node)
      if node.features.map(&:feature_configuration).include?(parent)
        feature = node.features.where(feature_configuration_id: parent.id.to_s).first
      else
        feature = node.features.build
        feature.feature_configuration = parent
        feature.send("build_#{feature_type}")
      end

      feature.child.class.add_value(value_name)
    end

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
        list_item_ids = Features::ListItem.find(params["#{machine_name}"]).map(&:id)
        NodeQuery.new.in(:"#{where}" => list_item_ids).selector
      else
        {}
      end
    end

    private
    def where
      where = "features."
      where += "#{parent.feature_type}."
      where += "#{parent.value_name.singularize}_ids"
      where
    end
  end
end