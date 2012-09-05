module Features
  class ListItem
    include Mongoid::Document
    belongs_to :list_feature_configuration, class_name: "Features::ListFeatureConfiguration"
    field :name, type: String
    validates :name, presence: :true
  end
end