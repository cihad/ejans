class AddPublishedToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :published, :boolean, :default => false
  end
end
