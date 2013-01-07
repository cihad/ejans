class NodeView
  include Mongoid::Document
  include Mongoid::Timestamps

  ## fields
  field :css
  field :js
  field :user_input_node_template,
        default: %q{<h3><%= node.title %></h3>}

  ## validations
  validates_presence_of :user_input_node_template

  ## associations
  embedded_in :node_type

  def fill_a_sample_view=(whatever)
    self.user_input_node_template = TableViewNodeTemplate.new(node_type).to_s
  end
end