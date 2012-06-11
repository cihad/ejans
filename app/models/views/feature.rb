module Views
  class Feature
    include Mongoid::Document

    # Fields
    field :position, type: Integer

    # Associations
    belongs_to :feature_configuration, class_name: "Features::FeatureConfiguration"
    embedded_in :view, class_name: "Views::View"

    # Scopes
    default_scope order_by([:position, :asc])
  end
end