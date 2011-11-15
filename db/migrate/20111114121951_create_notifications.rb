class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :service
      t.string :title
      t.string :sms
      t.text :description

      t.timestamps
    end
    add_index :notifications, :service_id
  end
end
