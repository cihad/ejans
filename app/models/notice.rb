# == Schema Information
#
# Table name: notices
#
#  id                :integer(4)      not null, primary key
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
  has_and_belongs_to_many :subscriptions, join_table: "notices_subscriptions"
  belongs_to :notification

  # Scopes
  default_scope order("id DESC")
  scope :unread, where(read: false)

  # Callbacks
  after_create :decrement_credit_from_account

  def decrement_credit_from_account
    subscriptions.each do |subscription|
      account_credit = subscription.account.credit # subscription self
      receiver_credit = subscription.service.service_price.receiver_credit.to_i # notification self
      account_credit.credit.to_i   < receiver_credit ? update_attributes(:sufficient_credit => false) : account_credit.decrement!(:credit, receiver_credit) # upd attr self
    end
  end
end
