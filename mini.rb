require 'open-uri'
require 'nokogiri'
require 'byebug'
require 'csv'



link = 'https://www.tokopedia.com/bom1/deanova-kaftan-abaya-gamis-fashion-muslim-terbaru-baju-wanita-termurah?whid=0'
html = open(link)
doc = Nokogiri::HTML(html)
doc.encoding = 'utf-8'
product_title = doc.css('h1.css-v7vvdw').text

price = doc.css('div.price').text
product_price = price.gsub(/\D/,'').to_i

desc  = doc.css('div[data-testid="lblPDPDescriptionProduk"]')
desc.search('br').each {|n| n.replace("\n")}
product_desc = desc.text
puts product_desc

CSV.open(File.join(Dir.pwd, "products.csv"), "w") do |csv|
  csv << [1, product_desc]
end




