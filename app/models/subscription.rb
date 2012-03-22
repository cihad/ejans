# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer(4)      not null, primary key
#  account_id :integer(4)
#  service_id :integer(4)
#  email      :boolean(1)      default(FALSE)
#  sms        :boolean(1)      default(FALSE)
#  active     :boolean(1)      default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

class Subscription < ActiveRecord::Base

  # Associations
  belongs_to :account
  belongs_to :service

  has_and_belongs_to_many :selections, :join_table => "subscriptions_selections"

  has_many :notices
  has_many :notifications, :through => :notices

  # Callbacks
  after_commit :do_false

  # Validates
  #validate :filter_count

  # When user creating subscription
  def valid_filter?(selection_ids)
    if selection_ids.nil?
      false
    else
      array = selection_ids.inject([]) { |a, id| a << Selection.find(id).filter_id }
      array.uniq.size == self.service.filters.size ? true : false
    end
  end

  def selections_map
    h = Hash.new { |hash, key| hash[key] = [] }
    self.selections.inject(h) { |hash, selection| hash[selection.filter.id] << selection.id; hash }
  end

  def selected_notification?(notification)
    notification_selections_map = notification.selections_map
    self.selections_map.inject([]) do |a, filter_selection|
      filter_id, selection_ids = filter_selection
      a << (selection_ids & notification_selections_map[filter_id]).present?
      a
    end.all? { |result| result == true }
  end

  def notifications
    service.notifications.select { |notification| selected_notification?(notification) }
  end

  def notice(notification)
    self.notices.find_by_notification_id(notification.id)
  end

  def have_notice?(notification)
    self.notice(notification).present?
  end

  def access_notification?(notification)
    self.have_notice?(notification) ? self.notice(notification).sufficient_credit? : false
  end

  def have_notice?(notification)
    notices.find_by_notification_id(notification.id) ? true : false
  end

  private
  def do_false
    self.notices.update_all :new => false
  end

  # def filter_count
  #   selections = Selection.includes(:filter).find(selection_ids)
  #   array = selections.inject([]) { |a, selection| a << selection.filter.id }
  #   unless array.uniq.size == self.service.filters.size
  #     errors[:base] << 'Please select minumum a item from each filter.'
  #     false
  #   end
  # end
end
