class CreateCreditHistories < ActiveRecord::Migration
  def change
    create_table :credit_histories do |t|
      t.references :credit
      t.references :credit_datable, :polymorphic => true
      t.integer :credit_quantity
      t.decimal :price, :precision => 5, :scale => 2

      t.timestamps
    end
    add_index :credit_histories, :credit_id
    add_index :credit_histories, :credit_datable_id
  end
end
