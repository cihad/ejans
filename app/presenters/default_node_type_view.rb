class DefaultNodeTypeView

  def id
    "default"
  end

  def css; end

  def js; end

  def node_type_template
    %q{
      <table class="table table-hover">
        <%= @nodes %>
      </table>
    }
  end

  def node_template
    %q{
      <tr>
        <td>
          <a href="<%= @node.path %>" data-remote>
            <%= @node.title %>
          </a>
        </td>
      </tr>
    }
  end

end