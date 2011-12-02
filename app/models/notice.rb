class Notice < ActiveRecord::Base
  # Associations
  belongs_to :subscription
  belongs_to :notification

  # Scopes
  default_scope order("id DESC")
end
