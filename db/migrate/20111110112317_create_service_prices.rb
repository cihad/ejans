class CreateServicePrices < ActiveRecord::Migration
  def change
    create_table :service_prices do |t|
      t.references :service
      t.integer :sender_credit, :default => 0
      t.integer :receiver_credit, :default => 0 

      t.timestamps
    end
  end
end
