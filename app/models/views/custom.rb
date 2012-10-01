module Views
  class Custom < View
    field :css, type: String
    field :js,  type: String
    field :user_input_node_template, type: String
    field :user_input_node_type_template, type: String

    def node_template
      user_input_node_template || %q{
        <tr>
          <td>
            <a href="<%= node_path %>" data-remote="true">
              <%= node.title %>
            </a>
          </td>
        </tr>
      }
    end

    def node_type_template
      user_input_node_type_template || %q{
        <table class="table"><%= nodes %></table>
      }
    end
  end
end