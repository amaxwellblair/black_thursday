require 'CSV'
require 'item_repository'
require 'merchant_repository'
require 'bigdecimal'
require 'pry'

class SalesEngine
  attr_reader :items, :merchants

  def initialize
    @items = ItemRepository.new
    @merchants = MerchantRepository.new
  end

  def load_data(path_hash)
    items.load_data(path_hash[:items]) if !path_hash[:items].nil?
    merchants.load_data(path_hash[:merchants]) if !path_hash[:merchants].nil?
  end

end
