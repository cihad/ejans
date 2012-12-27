class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Workflow
  include Ejans::Registerable

  ## fields
  field :role, default: "anonymous"

  ## associations
  has_many :nodes, inverse_of: :author, dependent: :destroy

  has_many :own_node_types, class_name: "NodeType",
    inverse_of: :super_administrator

  has_and_belongs_to_many :managed_node_types,
    class_name: "NodeType",
    inverse_of: :administrators

  ## callbacks
  before_create :set_role

  ## workflow
  workflow_column :role

  workflow do
    state :anonymous do
      event :signup, transitions_to: :registered
      event :visitor, transitions_to: :pending_for_signup
    end

    state :pending_for_signup do
      event :signup, transitions_to: :registered
    end

    state :registered do
      event :admin, transitions_to: :admin
    end
    
    state :admin
  end

private

  def set_role
    if valid?
      self.role = "registered"
    elsif email.present? && encrypted_password.blank?
      self.role = "pending_for_signup"
    end
  end
end