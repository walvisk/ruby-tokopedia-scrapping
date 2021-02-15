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

    @products.each_with_index do |product, index|
      worksheet.write_value(row = write_index, col = 1, index+1, format = nil)
      worksheet.write_value(row = write_index, col = 2, product[0], format = nil)
      worksheet.write_value(row = write_index, col = 3, product[1], format = nil)
      worksheet.write_value(row = write_index, col = 4, product[2], format = nil)
      worksheet.write_value(row = write_index, col = 5, product[3], format = nil)
      worksheet.write_value(row = write_index, col = 6, product[5], format = nil)

      puts "Menulis Data #{write_index}"
      save_image(product[4], write_index, folder)

      write_index += 1
    end

    workbook.close
  end

  def save_image(img_link, index, folder)
    open(img_link) do |u|
      File.open(File.join(Dir.pwd, "/#{folder}/images/#{index}.jpg"), 'wb') { |f| f.write(u.read) }
    end
    puts "gambar ke-#{index} telah disimpan"
  end
end