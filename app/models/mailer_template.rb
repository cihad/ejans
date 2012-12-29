class MailerTemplate
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :node_type
  field :title
  field :subject
  field :template
end