class CreateNotificationsSelectionsJoinTable < ActiveRecord::Migration
  def change
    create_table :notifications_selections, :id => false do |t|
      t.references :notification
      t.references :selection
    end

    add_index :notifications_selections, :notification_id
    add_index :notifications_selections, :selection_id
  end
end
