class CreateServicesNotificationsSelectionsJoinTable < ActiveRecord::Migration
  def change
    create_table :services_notifications_selections, :id => false do |t|
      t.integer :services_notification_id
      t.integer :selection_id
    end

    add_index :services_notifications_selections, :services_notification_id, name: 'services_notification_id_index'
    add_index :services_notifications_selections, :selection_id, name: 'services_notification_selection_id_index'
  end
end
