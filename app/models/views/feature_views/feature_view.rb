module Views
  module FeatureViews
    class FeatureView
      include Mongoid::Document

      # Associations
      embedded_in :view, class_name: "Views::NodeViews::View"
      VIEW_TYPES = [:integer, :string]
      VIEW_TYPES.each do |view_type|
        embeds_one :"#{feature_type}_feature_view", class_name: "Views::FeatureViews::#{view_type.to_s.camelize}FeatureView"
        accepts_nested_attributes_for :"#{view_type}_feature_view"
      end
    end
  end
end