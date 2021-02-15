require 'json'
require 'byebug'

class ConfigRepository
  attr_reader :folder_name, :keyword, :desired_count, :start_index
  def initialize(folder_name, keyword, desired_count, start_index)
    @folder_name   = folder_name
    @keyword       = keyword
    @desired_count = desired_count
    @start_index   = start_index
  end
end