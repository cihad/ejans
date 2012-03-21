require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'uri'


file = "http://www.google.com/alerts/feeds/02580315660967922904/13117523048547669761"
xml_doc  = Nokogiri::XML(open(file))
xml_doc.css("entry link").each do |link|
  file = URI.unescape(link[:href].split("http://www.google.com/url?sa=X&q=")[1].split("&ct=ga&cad=")[0])
  puts file
  # http://www.haber7.com/haber/20120313/2-milyon-tiryaki-27-milyar-dolar-istiyor.php
  # file = "sample_news.html"
  # file = "http://www.haberturk.com/gundem/haber/724142-basbakandan-444-kavgasina-ilk-yorum"
  content = open(file)
  doc = Nokogiri::HTML(content)
  temp = []

  doc.css("div").each do |div|
    if div.css("div p").count == 0 && div.css("p").count != 0
      p_count = div.css("p").count

      # total = div.css("p").map { |p| p.text.size }.reduce(:+)
      puts "############## Paragraph count = #{p_count} ##############"
      temp << [p_count, div]
    end
  end

  temp.sort_by { |array| array.first.to_i }.last(1).each do |array|
    array.last.css("p").each { |p| puts "#{p}".chomp.strip }
  end
  sleep 5
end