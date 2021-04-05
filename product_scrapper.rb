require 'open-uri'
require 'nokogiri'
require 'byebug'


class ProductScrapper
  def initialize(product_links)
    @product_links = product_links
  end

  def call(config)
    result = []
    @product_links.each_with_index do |link, index|
      item = []
      html = nil

      begin
        puts "link product = #{link}"
        html = open(link)
      rescue => exception
        puts "error"
        next
      end

      doc = Nokogiri::HTML(html)
      doc.encoding = 'utf-8'

      product_title = doc.css('h1.css-v7vvdw').text

      price = doc.css('div.price').text
      product_price = price.gsub(/\D/,'').to_i

      desc  = doc.css('div[data-testid="lblPDPDescriptionProduk"]')
      desc.search('br').each {|n| n.replace("\n")}
      product_desc = desc.text

      img_wrapper = doc.css('img.success.fade').attr('src')
      img_link = 'link'
      product_img_link = 'link'
      unless img_wrapper&.nil?
        img_link = doc.css('img.success.fade').attr('src').value
        product_img_link = img_link.sub('500-square', '900')
      end

      link_toko = link.split("/")[0..-2].join("/")
      product_location = get_product_location(link_toko)
      location = "Tokopedia | #{product_location}"

      item << product_title
      item << product_price
      item << product_desc
      item << location
      item << link
      item << product_img_link

      result << item
      puts "Proses Data #{index + 1} dari #{config.desired_count}"
    end

    result
  end

  def get_product_location(link_toko)
    html = open(link_toko)
    doc = Nokogiri::HTML(html)
    doc.encoding = 'utf-8'
    doc.css("p.css-dxunmy-unf-heading.e1qvo2ff8").children&.last&.text
  end
end

