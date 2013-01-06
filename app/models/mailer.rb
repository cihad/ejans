class Mailer

  include Mongoid::Document

  ## fields
  field :mailer_template_id, type: Moped::BSON::ObjectId
  
  ## assciations
  embedded_in :node_type
  has_and_belongs_to_many :potential_users

  ## validations
  validates_presence_of :mailer_template_id

  ## methods
  def mailer_template
    node_type.mailer_templates.find(mailer_template_id)
  end
  
end