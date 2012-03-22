class AddViewToExternalSources < ActiveRecord::Migration
  def change
    add_column :external_sources, :view, :boolean, :default => false

  end
end
