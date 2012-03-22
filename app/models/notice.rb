# == Schema Information
#
# Table name: notices
#
#  id                :integer(4)      not null, primary key
#  subscription_id   :integer(4)
#  notification_id   :integer(4)
#  read              :boolean(1)      default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#  new               :boolean(1)      default(TRUE)
#  sufficient_credit :boolean(1)      default(TRUE)
#

class Notice < ActiveRecord::Base

  # Associations
  belongs_to :account
  belongs_to :subscription
  belongs_to :notification

  # Scopes
  default_scope order("id DESC")

  # Callbacks
  after_create :decrement_credit_from_account

  def decrement_credit_from_account
    account_credit = subscription.account.credit # subscription self
    receiver_credit = notification.service.service_price.receiver_credit.to_i # notification self
    account_credit.credit.to_i   < receiver_credit ? update_attributes(:sufficient_credit => false) : account_credit.decrement!(:credit, receiver_credit) # upd attr self
  end
end
