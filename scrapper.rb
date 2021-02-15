require 'watir'
require 'open-uri'
require 'byebug'
require 'webdriver-user-agent'
require 'nokogiri'
# require './product_scrapper'
# require './excel_generator'

data = []
url = 'https://www.tokopedia.com/search?page=1&q=essence&st=product'
browser = Watir::Browser.new
browser.goto(url)

original_count = browser.divs(class: 'css-1mswclh').count
# Take an whatever action to trigger the loading of more posts
browser.scroll.to :bottom

# Wait for the count to increase
browser.wait_until do
  wrapper_count = browser.divs(class: 'css-1mswclh').count
  wrapper_count > original_count
end
# browser.div(:class => 'css-1mswclh').wait_until(&:present?)
# browser.scroll.to :bottom

# html = open(url)

doc = Nokogiri::HTML(browser.html)
wrapper_products = doc.css('div.css-7fmtuv')

puts wrapper_products.size

wrapper_products.each_with_index do |wrp, index|
  result = []

  location_wrapper = wrp.css('div.css-16hun4e')

  next if location_wrapper.empty?

  product_location = location_wrapper.children.first.text
  result << product_location

  product_link = wrp.children.first.attr('href')
  fixed_link = product_link
  if product_link.slice(0, 24) == 'https://ta.tokopedia.com'
    parsed_link = URI.parse(product_link)
    query_params = URI.decode_www_form(parsed_link.query).to_h
    fixed_link = query_params['r']
  end
  result << fixed_link

  data << result
end

# products = ProductScrapper.new(data).call

# ExcelGenerator.new.call(products)

