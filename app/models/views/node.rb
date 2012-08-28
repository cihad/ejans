module Views
  class Node
    include Mongoid::Document
    field :css, type: String
    field :js,  type: String
    field :user_input_node_template, type: String

    embedded_in :node_type

    def node_type_template
      %q{<div class='node'>
        <%= node %>
      </div>}
    end

    def node_template
      if user_input_node_template.blank?
        %q{<h3><%= node_title %></h3>}
      else
        user_input_node_template
      end
    end
  end
end
