class CreateAccountsRolesJoinTable < ActiveRecord::Migration
  def change
    create_table :accounts_roles, :id => false do |t|
      t.references :account
      t.references :role
    end

    add_index :accounts_roles, :account_id
    add_index :accounts_roles, :role_id
  end
end
