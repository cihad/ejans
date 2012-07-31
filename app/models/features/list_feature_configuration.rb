module Features
  class ListFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::Filterable

    field :maximum_select, type: Integer
    has_many :list_items, class_name: "Features::ListItem"
    accepts_nested_attributes_for :list_items,
      reject_if: ->(attrs){ attrs[:name].blank? }

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
      "#{key_name.to_s.singularize}_ids"
    end
  end
end