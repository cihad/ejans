module Views
  class View
    include Mongoid::Document
    include Mongoid::Timestamps

    attr_accessor :conf_id

    # Fields
    field :position, type: Integer
    field :type, type: Symbol
    field :style, type: String

    VIEW_TYPES = [:flat, :list, :table, :grid, :node]

    # Associations
    belongs_to :node_type
    embeds_many :features, class_name: "Views::Feature"
    accepts_nested_attributes_for :features

    # Scopes
    default_scope order_by([:position, :asc])

    validate :view_count

    def conf_id=(id)
      self.features.build(feature_configuration_id: Features::FeatureConfiguration.find(id).id, position: 10)
    end

    def build_assoc!
      node_type.feature_configurations.each_with_index do |fc, i|
        feature = self.features.build
        feature.feature_configuration = fc
        feature.position = i+1
      end
      self.save if new_record?
    end

    private
    def view_count
      if self.node_type.views.count >= 3
        errors.add(:base, "Views sayisi 3'ten buyuk olamaz.")
      end
    end
  end
end