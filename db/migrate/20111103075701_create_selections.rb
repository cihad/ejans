class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.integer :filter_id
      t.string :label

      t.timestamps
    end
  end
end
