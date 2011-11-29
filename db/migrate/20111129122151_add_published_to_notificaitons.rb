class AddPublishedToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :published, :booelan, :default => false
  end
end
