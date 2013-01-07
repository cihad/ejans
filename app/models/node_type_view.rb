class NodeTypeView
  include Mongoid::Document
  include Mongoid::Timestamps

  ## fields
  field :css
  field :js
  field :user_input_node_type_template
  field :user_input_node_template
  field :position, type: Integer
  field :icon, default: "icon-align-justify"

  alias :node_type_template :user_input_node_type_template
  alias :node_template :user_input_node_template

  ## associations
  embedded_in :node_type

  ## validations
  validates_presence_of :user_input_node_template
  validate :view_count
  
  ## scopes
  default_scope order_by([:position, :asc])

private

  def view_count
    if node_type.node_type_views.size > 2
      errors.add(:base, "En fazla 2 view ekleyebilirsiniz.")
    end
  end
end