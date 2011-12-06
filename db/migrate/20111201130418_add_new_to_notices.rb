class AddNewToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :new, :boolean, :default => true
  end
end
