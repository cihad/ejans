module Views
  class Node < Custom
    def node_type_template
      %q{
        <div class='node'>
          <%= node %>
        </div>
      }
    end

    def node_template
      if user_input_node_template.blank?
        %q{<h3><%= node_title %></h3>}
      else
        user_input_node_template
      end
    end

    def destroy_from_inside
      false
    end
  end
end
