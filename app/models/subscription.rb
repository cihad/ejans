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

  private

    def false_new
      self.notices.update_all :new => false
    end
end
