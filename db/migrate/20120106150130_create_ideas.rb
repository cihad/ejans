class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.references :account
      t.string :search_string
      t.text :suggestion
      t.string :email

      t.timestamps
    end
    add_index :ideas, :account_id
  end
end
