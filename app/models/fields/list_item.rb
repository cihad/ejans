module Fields
  class ListItem
    include Mongoid::Document
    field :name, type: String
    validates :name, presence: true
    field :position, type: Integer, default: 1000
    default_scope order_by([:position, :asc])
  end
end