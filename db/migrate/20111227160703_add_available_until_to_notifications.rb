class AddAvailableUntilToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :available_until, :date
  end
end
