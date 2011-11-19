class CreateSubscriptionsSelectionsJoinTable < ActiveRecord::Migration
  def change
    create_table :subscriptions_selections, :id => false do |t|
      t.references :subscription
      t.references :selection
    end

    add_index :subscriptions_selections, :subscription_id
  end
end