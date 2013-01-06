Fabricator :node_type_view do

  css %q{}

  js %q{}

  user_input_node_type_template %q{<table class='table'>
    <%= nodes %>
  </table>}

  user_input_node_template %q{<tr>
    <td>
      <a href="<%= node.path %>" data-remote>
        <%= node.title %>
      </a>
    </td>
  </tr>}

end