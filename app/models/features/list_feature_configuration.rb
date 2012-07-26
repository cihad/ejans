module Features
  class ListFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::Filterable

    # Fields
    field :maximum_select, type: Integer

    # Associations
    has_many :list_items, class_name: "Features::ListItem"
    accepts_nested_attributes_for :list_items,
      reject_if: ->(attrs){ attrs[:name].blank? }

    # Object Methods
    def build_assoc!(node)
      Features::ListFeature.set_key(key_name)
      if node.features.map(&:feature_configuration).include?(self)
        feature = node.features.where(feature_configuration_id: self.id.to_s).first
      else
        feature = node.features.build({}, Features::ListFeature)
        feature.feature_configuration = self
      end
    end


    def filter_query(params = {})
      if params[machine_name].present?
        list_item_ids = Features::ListItem.find(params[machine_name]).map(&:id)
        NodeQuery.new.in(:"#{where}" => list_item_ids).selector
      else
        {}
      end
    end

    private
    def where
      "features." +
      "#{conf.key_name.singularize}_ids"
    end
  end
end