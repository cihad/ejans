class Subscription < ActiveRecord::Base
  # Associations
  belongs_to :account
  belongs_to :service

  has_and_belongs_to_many :selections, :join_table => "subscriptions_selections"

  has_many :notices
  has_many :notifications, :through => :notices

  # Callbacks
  after_commit :false_new

  # When user creating subscription
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

  private

    def false_new
      self.notices.update_all :new => false
    end
end
