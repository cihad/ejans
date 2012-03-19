class CreateGoogleAlertFeeds < ActiveRecord::Migration
  def change
    create_table :google_alert_feeds do |t|
      t.references :service
      t.string :feed_url
      t.string :search_key

      t.timestamps
    end
    add_index :google_alert_feeds, :service_id
  end
end
