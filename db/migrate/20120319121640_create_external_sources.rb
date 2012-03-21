class CreateExternalSources < ActiveRecord::Migration
  def change
    create_table :external_sources do |t|
      t.references :google_alert_feed
      t.string :url

      t.timestamps
    end
    add_index :external_sources, :google_alert_feed_id
  end
end
