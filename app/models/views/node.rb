module Views
  class Node < Custom
    def node_type_template
      if user_input_node_type_template.blank? 
        %q{
          <div class='node'>
            <%= node %>
          </div>
        }
      else
        user_input_node_type_template
      end
    end

    def node_template
      if user_input_node_template.blank?
        %q{
          <p>
            <%= node_title %>
          </p>
        }
      else
        user_input_node_template
      end
    end
  end
end
