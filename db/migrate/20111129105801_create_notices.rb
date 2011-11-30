class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.references :subscription
      t.references :notification
      t.boolean :read

      t.timestamps
    end
    add_index :notices, :subscription_id
    add_index :notices, :notification_id
  end
end
