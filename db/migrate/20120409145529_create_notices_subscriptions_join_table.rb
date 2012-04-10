class CreateNoticesSubscriptionsJoinTable < ActiveRecord::Migration
  def change
    create_table :notices_subscriptions, :id => false do |t|
      t.references :notice
      t.references :subscription
    end

    add_index :notices_subscriptions, :notice_id
    add_index :notices_subscriptions, :subscription_id
  end
end
