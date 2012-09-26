module Fields
  class ListItem
    include Mongoid::Document
    belongs_to  :list_feature_configuration,
                class_name: "Fields::ListFieldConfiguration"
    field :name, type: String
    validates :name, presence: :true
  end
end