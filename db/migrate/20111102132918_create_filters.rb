class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.integer :service_id
      t.string :name

      t.timestamps
    end
  end
end
