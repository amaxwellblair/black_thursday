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

  def self.from_csv(path_hash)
    sales_engine = self.new
    sales_engine.items.load_data(path_hash[:items]) if !path_hash[:items].nil?
    sales_engine.merchants.load_data(path_hash[:merchants]) if !path_hash[:merchants].nil?
    sales_engine
  end

end
