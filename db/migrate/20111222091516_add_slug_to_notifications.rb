class AddSlugToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :slug, :string
    add_index :notifications, :slug, :unique => true
  end
end
