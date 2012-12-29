class Mailer
  include Mongoid::Document
  embedded_in :node_type
  field :mailer_template_id, type: Moped::BSON::ObjectId
  has_and_belongs_to_many :potential_users

  def mailer_template
    node_type.mailer_templates.find(mailer_template_id)
  end
end