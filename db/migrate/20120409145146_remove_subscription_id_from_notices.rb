class RemoveSubscriptionIdFromNotices < ActiveRecord::Migration
  def up
    remove_index :notices, :subscription_id
    remove_column :notices, :subscription_id
  end

  def down
    add_column :notices, :subscription_id, :integer
    add_index :notices, :subscription_id
  end
end
