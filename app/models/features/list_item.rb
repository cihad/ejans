module Features
  class ListItem
    include Mongoid::Document

    # Associations
    belongs_to :list_feature_configuration, class_name: "Features::ListFeatureConfiguration"

    # Fields
    field :name, type: String

    # Validates
    validates :name, presence: :true
  end
end