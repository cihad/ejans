class RemoveServiceIdFromNotifications < ActiveRecord::Migration
  def up
    remove_index :notifications, :service_id
    remove_column :notifications, :service_id
  end

  def down
    add_column :notifications, :service_id, :string
    add_index :notifications, :service_id
  end
end
