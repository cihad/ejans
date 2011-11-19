class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :account
      t.references :service
      t.boolean :email, :default => false
      t.boolean :sms, :default => false
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :subscriptions, :account_id
    add_index :subscriptions, :service_id
  end
end
