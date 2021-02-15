require './config_repository'
require './products_scrapper'
require './product_scrapper'
require './excel_generator'
# require './csv_generator'

class App
  def initialize; end

  def call
    print 'Masukkan Keyword : '
    keyword = gets.to_s.chop!

    if keyword.empty?
      puts 'No Keyword'
      program_terminated
      return
    end

    print 'Masukkan Jumlah Data Yang Diingikan: '
    desired_count = gets.to_i

    if desired_count.zero?
      puts 'Tidak ada jumlah'
      program_terminated
      return
    end

    print 'Masukkan Nomor Urut Mulai: '
    start_index = gets.to_i
    start_index = 1 if start_index.zero?

    snake_case_keyword = keyword.downcase.tr(" ", "_").to_s
    folder_name = "#{snake_case_keyword}_#{start_index}_#{start_index + desired_count}"

    puts "Membuat Folder #{folder_name}"

    if Dir.exists?("./#{folder_name}")
      puts 'Scraping sudah pernah dilakukan'
      program_terminated
      return
    end

    create_scrapping_folder(folder_name)
    puts "Folder #{folder_name} sudah dibuat"

    puts "Membuat Konfigurasi"
    config = ConfigRepository.new(folder_name, keyword, desired_count, start_index)
    puts 'Selesai Membuat Konfigurasi'

    puts 'Memulai Mengambil Daftar Produk (y/n) ? '
    start_1 = gets.to_s.chop!

    if start_1 == 'n'
      program_terminated
      return
    end

    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    list_product = ProductsScrapper.new(config).call

    puts 'Mengambil Data Per Produk'
    product_items = ProductScrapper.new(list_product).call(config)

    puts 'Membuat Excel File'
    ExcelGenerator.new(product_items).call(config)

    # puts 'Membuat CSV File'
    # CsvGenerator.new(product_items).call(config)

    puts 'Selesai'

    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting

    puts "Waktu Proses #{Time.at(elapsed).utc.strftime("%H:%M:%S")}"
    program_terminated
  end

  private

  def program_terminated
    puts 'Program Terminated'
  end

  def create_scrapping_folder(name)
    Dir.mkdir("./#{name}")
  end
end

App.new.call