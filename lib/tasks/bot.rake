require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'uri'

desc "Bot"
task :bot => :environment do
  temp = 0
  GoogleAlertFeed.all.each do |feed|
    feed_url = feed.feed_url
    xml_doc  = Nokogiri::XML(open(feed_url))
    xml_doc.css("entry link").each do |source|
      source_url = URI.unescape(source[:href])
      begin
        ExternalSource.find_by_url(source_url)
        next
      rescue
        ext_source = ExternalSource.new
        ext_source.url = source_url
        ext_source.google_alert_feed_id = feed.id
        ext_source.save
        temp += 1
      end
    end
  end

  puts "Added links count: #{temp}"
end