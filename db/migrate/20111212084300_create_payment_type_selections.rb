class CreatePaymentTypeSelections < ActiveRecord::Migration
  def change
    create_table :payment_type_selections do |t|
      t.references :payment_type
      t.integer :credit
      t.decimal :price, :scale => 2
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
