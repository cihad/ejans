module Views
  class PlacePage < Node
    def node_type_template
      self.class.node_type_template
    end

    def node_template
      if user_input_node_template.blank?
        %q{<p><%= (node_title + " ") * 10 %><br /></p>}
      else
        user_input_node_template
      end
    end

    def self.node_type_template
      %q{<div class="node span2">
          <div class="node-ins">
            <%= nodes %>
          </div>
        </div>}
    end
  end
end
