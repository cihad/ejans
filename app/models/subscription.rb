class Subscription < ActiveRecord::Base
  # Associations
  belongs_to :account
  belongs_to :service

  has_and_belongs_to_many :selections, :join_table => "subscriptions_selections"

  has_many :notices
  has_many :notifications, :through => :notices

  def valid_filter?(selection_ids)
    if selection_ids.nil?
      false
    else
      array = []
      selection_ids.each do |id|
        array << Selection.find(id).filter_id
      end

      if array.uniq.size == self.service.filters.size
        true
      else
        false
      end
    end
  end

  def self.unread_notice_count
    notices.where(:read => false).count
  end

end
