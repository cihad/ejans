class CreateAccountCredits < ActiveRecord::Migration
  def change
    create_table :account_credits do |t|
      t.references :account
      t.integer :credit

      t.timestamps
    end
    add_index :account_credits, :account_id
  end
end
