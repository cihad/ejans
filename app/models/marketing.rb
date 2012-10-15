class Marketing
  include Mongoid::Document
  embedded_in :node_type
  field :marketing_template_id, type: Moped::BSON::ObjectId
  has_and_belongs_to_many :potential_users

  def marketing_template
    node_type.marketing_templates.find(marketing_template_id)
  end
end