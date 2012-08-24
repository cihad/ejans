module Features
  class ListFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::Filterable

    field :maximum_select, type: Integer
    has_many :list_items, class_name: "Features::ListItem"
    accepts_nested_attributes_for :list_items,
      reject_if: ->(attrs){ attrs[:name].blank? }

    def data_names
      super + if maximum_select > 1
                [:"#{machine_name}_values"]
              else
                [:"#{machine_name}_value"]
              end
    end

    def data_for_node
      super.merge({
        :"#{machine_name}_maximum_select" => maximum_select
        })
    end

    def filter_query(params = {})
      if params[machine_name].present?
        list_item_ids = Features::ListItem.find(params[machine_name]).map(&:id)
        NodeQuery.new.in(:"#{where}" => list_item_ids)
      else
        NodeQuery.new
      end
    end

    private
    def where
      "features." +
      "#{key_name.to_s.singularize}_ids"
    end
  end
end