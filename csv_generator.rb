require 'csv'

class CsvGenerator
  def initialize(products)
    @products = products
  end

  def call(config)
    CSV.open(File.join(Dir.pwd, "/#{config.folder_name}/products.csv"), "w") do |csv|
      @products.each do |product|
        csv << product
      end
    end
  end
end