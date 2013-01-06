class MailerTemplate

  include Mongoid::Document
  include Mongoid::Timestamps

  
  ## fields
  field :title
  field :subject
  field :template

  ## associations
  embedded_in :node_type

  ## validtions
  validates_presence_of :title, :subject, :template
  
end