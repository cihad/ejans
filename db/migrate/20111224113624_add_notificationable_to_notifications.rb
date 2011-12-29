class AddNotificationableToNotifications < ActiveRecord::Migration  
  def self.up
    change_table :notifications do |t|
      t.references :notificationable, :polymorphic => true
    end
  end

  def self.down
    change_table :notifications do |t|
      t.remove_references :notificationable, :polymorphic => true
    end
  end
end
