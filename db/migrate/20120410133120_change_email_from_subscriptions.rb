class ChangeEmailFromSubscriptions < ActiveRecord::Migration
  def up
    change_column_default :subscriptions, :email, true
  end

  def down
    change_column_default :subscriptions, :email, false
  end
end
