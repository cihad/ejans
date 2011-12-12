class CreateCreditHistories < ActiveRecord::Migration
  def change
    create_table :credit_histories do |t|
      t.references :credit
      t.references :payment_type
      t.references :credit_datable
      t.integer :credit
      t.decimal :price

      t.timestamps
    end
    add_index :credit_histories, :credit_id
    add_index :credit_histories, :payment_type_id
    add_index :credit_histories, :credit_datable_id
  end
end
