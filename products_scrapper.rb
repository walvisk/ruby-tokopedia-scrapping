require 'watir'
require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'uri'

require './config_repository'

class ProductsScrapper
  def initialize(config)
    @config = config
  end

  def call
    keyword       = @config.keyword
    desired_count = @config.desired_count

    output = Set.new
    puts 'Scrapping begin'

    page = 1
    loop do
      break if output.size == desired_count

      string_url = "https://www.tokopedia.com/search?page=#{page}&q=#{keyword}&st=product"
      # url = CGI.escape(string_url)
      url = URI::encode(string_url)
      puts "scrapping url: #{url}"

      html = open(url)
      doc = Nokogiri::HTML(html)

      wrapper_products = doc.css('div.css-7fmtuv')

      wrapper_products.each_with_index do |wrp, index|
        break if output.size == desired_count

        # wrapper_link = wrp.css('a.pcv3__info-content css-1qnnuob')
        wrapper_link = wrp.css('a')
        next if wrapper_link.empty?

        link_text    = wrapper_link.attribute('href').text
        link_product = link_text
        if link_text.slice(0, 24) == 'https://ta.tokopedia.com'
          parsed_link  = URI.parse(link_text)
          query_params = URI.decode_www_form(parsed_link.query).to_h
          link_product = query_params['r']
        end
        link = link_product[/[^\?]+/]

        output << link
      end
      puts "Jumlah Product Yang Telah Diambil = #{output.size} dari #{desired_count}"

      page += 1
    end

    output
  end
end
