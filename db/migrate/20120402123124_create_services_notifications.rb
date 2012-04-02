class CreateServicesNotifications < ActiveRecord::Migration
  def change
    create_table :services_notifications do |t|
      t.integer :notification_id
      t.integer :service_id

      t.timestamps
    end
    add_index :services_notifications, :notification_id
    add_index :services_notifications, :service_id
  end
end
