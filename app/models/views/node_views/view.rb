module Views
  module NodeViews
    class View
      include Mongoid::Document
      include Mongoid::Timestamps

      # Fields
      field :position, type: Integer

      # Associations
      belongs_to :node_type
      embeds_many :feature_view, class_name: "Views::FeatureViews::FeatureView"
      
      VIEW_TYPES = [:node, :list, :table]
      VIEW_TYPES.each do |view_type|
        embeds_one :"#{view_type}_view", class_name: "Views::NodeViews::#{view_type.to_s.camelize}View"
        accepts_nested_attributes_for :"#{view_type}_view"
      end

      # => "node"
      def type
        self.reflect_on_all_associations(:embeds_one).map(&:key).inject("") do |s, assoc|
          s << assoc if self.send(assoc)
          s
        end
      end
    end
  end
end