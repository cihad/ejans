class AddGoogleUrlToExternalSources < ActiveRecord::Migration
  def change
    add_column :external_sources, :google_url, :string

  end
end
