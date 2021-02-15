require 'watir'
require 'nokogiri'

require './config_repository'

class ProductsScrapper
  def initialize(config)
    @config = config
  end

  def call
    keyword       = @config.keyword
    desired_count = @config.desired_count

    browser = Watir::Browser.new

    products = []

    page = 1

    puts 'Scrapping begin'

    do_break = false
    loop do
      break if do_break == true
      url = "https://www.tokopedia.com/search?page=#{page}&q=#{keyword}&st=product"
      puts "scrapping url: #{url}"

      browser.goto(url)

      doc = Nokogiri::HTML(browser.html)
      wrapper_products = doc.css('div.css-7fmtuv')

      wrapper_products.each_with_index do |wrp, index|
        if products.size == desired_count
          do_break = true
          break
        end

        item = []

        location_wrapper = wrp.css('div.css-16hun4e')
        next if location_wrapper.empty?

        product_location = location_wrapper.children.first.text
        item << product_location

        product_link = wrp.children.first.attr('href')
        fixed_link = product_link
        if product_link.slice(0, 24) == 'https://ta.tokopedia.com'
          parsed_link = URI.parse(product_link)
          query_params = URI.decode_www_form(parsed_link.query).to_h
          fixed_link = query_params['r']
        end
        item << fixed_link

        products << item
      end

      page += 1
      puts "Jumlah Product Yang Telah Diambil = #{products.size} dari #{desired_count}"

    end
    products
  end
end