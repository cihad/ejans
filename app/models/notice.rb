class Notice < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :notification
end
