class Mailer

  include Mongoid::Document

  ## fields
  field :mailer_template_id, type: Moped::BSON::ObjectId
  
  ## assciations
  embedded_in :node_type
  has_and_belongs_to_many :potential_users

  ## methods
  def mailer_template
    node_type.mailer_templates.find(mailer_template_id)
  end
  
end