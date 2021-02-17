require 'fast_excel'
require 'open-uri'

class ExcelGenerator
  def initialize(products)
    @products = products
  end

  def call(config)
    folder      = config.folder_name
    write_index = config.start_index

    Dir.mkdir(File.join(Dir.pwd, "/#{folder}/images/"))

    workbook = FastExcel.open(File.join(Dir.pwd, "/#{folder}/result.xlsx"), constant_memory: true)
    worksheet = workbook.add_worksheet

    worksheet.write_value(row = 0, col = 1, 'NO', format = nil)
    worksheet.write_value(row = 0, col = 2, 'name', format = nil)
    worksheet.write_value(row = 0, col = 3, 'harga', format = nil)
    worksheet.write_value(row = 0, col = 4, 'deskripsi', format = nil)
    worksheet.write_value(row = 0, col = 5, 'lokasi', format = nil)
    worksheet.write_value(row = 0, col = 6, 'link', format = nil)

    excel_index = 1
    @products.each_with_index do |product, index|
      puts "Menulis Data ke-#{write_index}"

      worksheet.write_value(row = excel_index, col = 1, write_index, format = nil)
      worksheet.write_value(row = excel_index, col = 2, product[0], format = nil)
      worksheet.write_value(row = excel_index, col = 3, product[1], format = nil)

      description = product[2]
      description = product[0] if description.nil? || description.empty?
      worksheet.write_value(row = excel_index, col = 4, description, format = nil)

      worksheet.write_value(row = excel_index, col = 5, product[3], format = nil)
      worksheet.write_value(row = excel_index, col = 6, product[4], format = nil)

      puts "Menyimpan gambar ke-#{write_index}"
      save_image(product[5], write_index, folder)

      write_index += 1
      excel_index += 1
    end

    workbook.close
  end

  def save_image(img_link, index, folder)
    open(img_link) do |u|
      File.open(File.join(Dir.pwd, "/#{folder}/images/#{index}.jpg"), 'wb') { |f| f.write(u.read) }
    end
  end
end