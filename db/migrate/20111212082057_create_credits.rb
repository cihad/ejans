class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :creditable, :polymorphic => true
      t.integer :credit

      # t.timestamps
    end
    add_index :credits, :creditable_id
  end
end
