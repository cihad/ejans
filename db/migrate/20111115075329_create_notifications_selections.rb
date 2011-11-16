class CreateNotificationsSelections < ActiveRecord::Migration
  def change
    create_table :notifications_selections, :id => false do |t|
      t.references :notification
      t.references :selection
    end

    add_index :notifications_selections, :notification_id
    add_index :notifications_selections, :selection_id
    add_index :notifications_selections, [:notification_id, :selection_id], :name => "notification_id_and_selection_id", :unique => true
  end
end
