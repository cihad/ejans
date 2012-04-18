class RemoveAvailableUntilFromNotifications < ActiveRecord::Migration
  def up
    remove_column :notifications, :available_until
  end

  def down
    add_column :notifications, :available_until, :date
  end
end
