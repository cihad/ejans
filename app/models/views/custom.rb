module Views
  class Custom < View
    field :css, type: String
    field :js,  type: String
    field :user_input_node_template, type: String
    field :user_input_node_type_template, type: String

    def node_template
      user_input_node_template
    end

    def node_type_template
      user_input_node_type_template
    end
  end
end