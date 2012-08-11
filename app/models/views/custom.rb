module Views
  class Custom < View
    field :css, type: String
    field :js,  type: String
    field :node_layout, type: String
    field :node_type_layout, type: String
  end
end