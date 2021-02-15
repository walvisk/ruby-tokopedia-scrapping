require 'open-uri'
require 'nokogiri'
require 'byebug'


class ProductScrapper
  def initialize(products)
    @products = products
  end

  def call(config)
    result = []
    @products.each_with_index do |dt, index|
      item = []
      link = dt.last

      html = open(link)
      doc = Nokogiri::HTML(html)
      doc.encoding = 'utf-8'

      product_title = doc.css('h1.css-v7vvdw').text

      price = doc.css('div.price').text
      product_price = price.gsub(/\D/,'').to_i

      desc  = doc.css('div[data-testid="lblPDPDescriptionProduk"]')
      desc.search('br').each {|n| n.replace("\n")}
      product_desc = desc.text

      product_location = dt.first
      location = "Tokopedia | #{product_location}"

      img_link = doc.css('img.success.fade').attr('src').value
      product_img_link = img_link.sub('500-square', '900')


      item << product_title
      item << product_price
      item << product_desc
      item << location
      item << product_img_link
      item << link

      result << item
      puts "Proses Data #{index + 1} dari #{config.desired_count}"
    end

    result
  end
end

