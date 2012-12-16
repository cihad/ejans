class TableViewNodeTemplate
  def initialize(node_type)
    @node_type = node_type
  end

  def self.template
    %{<table class="table table-node table-striped table-hover">
      #{yield}
    </table>}
  end

  def self.row(field, &block)
    %{<tr>
      <th><%= #{field}.label %></th>
      <td>
        #{yield field}
      </td>
    </tr>}
  end

  def self.belongs_to(machine_name)
    "<%= node.#{machine_name}.title %>"
  end

  def self.boolean(machine_name)
    "<%= node.#{machine_name} ? #{machine_name}.on_value : #{machine_name}.off_value %>"
  end

  def self.date(machine_name)
    "<%= node.#{machine_name} %>"
  end

  def self.has_many(machine_name)
    %{<ul>
      <% node.#{machine_name}.each do |node| %>
        <li><a href="<%= node.path %>" data-remote><%= node.title %></a></li>
      <% end %>
    </ul>}
  end

  def self.image(machine_name)
    %{<% node.#{machine_name}.each do |image| %>
        <img src="<%= image.image_url(:thumb) %>" />
      <% end %>}
  end

  def self.integer(machine_name)
    %{<%= #{machine_name}.prefix %>
      <%= node.#{machine_name} %>
      <%= #{machine_name}.suffix %>}
  end

  def self.select(machine_name)
    "<%= node.#{machine_name}.map(&:name).join(', ') %>"
  end

  def self.place(machine_name)
    %{<% node.#{machine_name}.each do |row| %>
        <%= row.places.map(&:name).join(', ') %><br />
      <% end %>}
  end

  def self.string(machine_name)
    "<%= node.#{machine_name} %>"
  end

  def self.tag(machine_name)
    "<%= node.#{machine_name}.join(', ') %>"
  end

  def self.tree_category(machine_name)
    "<%= node.#{machine_name}.map(&:name).join(', ') %>"
  end

  def self.print_field(field_type, machine_name)
    row(machine_name) { |name| send(field_type, name) }
  end

  def to_s
    return self.class.template do
      @node_type.nodes_custom_fields.inject("") do |tmpl, field|
        tmpl << self.class.print_field(field.type, field.machine_name)
      end
    end
  end
end
