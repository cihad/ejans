class CreatePaymentTypeSelections < ActiveRecord::Migration
  def change
    create_table :payment_type_selections do |t|
      t.integer :credit
      t.decimal :price
      t.boolean :active

      t.timestamps
    end
  end
end
