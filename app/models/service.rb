class Service < ActiveRecord::Base
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "Account"
end
