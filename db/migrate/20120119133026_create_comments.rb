class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :notification
      t.integer :author_id
      t.text :body

      t.timestamps
    end
    add_index :comments, :notification_id
    add_index :comments, :author_id
  end
end
