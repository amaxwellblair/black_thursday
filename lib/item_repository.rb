require 'csv'
require 'time'
require_relative 'item'
require 'bigdecimal'
require 'pry'

class ItemRepository
  attr_accessor :internal_list

  def initialize
    @internal_list = []
  end

  def all
    internal_list
  end

  def find_by_id(id)
    internal_list.find{|item| id == item.id}
  end

  def find_by_name(name)
    internal_list.find{|item| name.downcase == item.name.downcase}
  end

  def find_all_by_merchant_id(merchant_id)
    internal_list.find_all{|item| merchant_id == item.merchant_id}
  end

  def find_all_with_description(substring)
    internal_list.find_all do |item|
      /#{Regexp.quote(substring.downcase)}\S*/ =~ item.description.downcase
    end
  end

  def find_all_by_price(unit_price)
    internal_list.find_all do |item|
      make_bigdecimal(unit_price) == item.unit_price
    end
  end

  def find_all_by_price_in_range(price_range)
    internal_list.find_all do |item|
      price = item.unit_price
      price.to_f >= price_range.first && price.to_f <= price_range.last
    end
  end

  def list_insert(args_hash)
    internal_list << create_item(args_hash)
  end

  def load_data(file_extension)
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
       list_insert(row.to_hash)
    end
  end

  def create_item(args)
    Item.new(args)
  end

  def make_bigdecimal(unit_price)
    if unit_price.class == String
      BigDecimal.new("#{unit_price}")
    else
      BigDecimal.new(unit_price)
    end
  end

  def inspect
    "#<#{self.class} #{@internal_list.size} rows>"
  end

end
