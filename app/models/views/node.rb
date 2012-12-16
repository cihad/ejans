module Views
  class Node
    include Mongoid::Document
    field :css
    field :js
    field :user_input_node_template

    embedded_in :node_type

    def node_type_template
      %q{<div class='node'>
        <%= node %>
      </div>}
    end

    def node_template
      if user_input_node_template.blank?
        %q{<h3><%= node.title %></h3>}
      else
        user_input_node_template
      end
    end

    def fill_a_sample_view=(whatever)
      self.user_input_node_template = TableViewNodeTemplate.new(node_type).to_s
    end
  end
end
