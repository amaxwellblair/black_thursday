require 'CSV'
require 'repository'
require 'bigdecimal'
require 'pry'

class ItemRepository
  attr_reader :internal_list

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

  def find_by_merchant_id(merchant_id)
    internal_list.find{|item| merchant_id == item.merchant_id}
  end

  def find_all_with_description(substring)
    internal_list.find_all do |item|
      /#{Regexp.quote(substring.downcase)}\S+/ =~ item.description.downcase
    end
  end

  def find_all_by_price(unit_price)
    internal_list.find_all do |item|
      BigDecimal.new("#{unit_price[0..-3]}.#{unit_price[-2..-1]}") == item.unit_price
    end
  end

  def find_all_by_price_in_range(price_range)
    internal_list.find_all do |item|
      price = item.unit_price
      price.to_f >= price_range.first && price.to_f <= price_range.last
    end
  end

  def list_insert(id, name, description, unit_price, created_at, updated_at, merchant_id)
    internal_list << create_item(id, name, description, unit_price, created_at, updated_at, merchant_id)
  end

  def load_data(file_extension)
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
       list_insert(row[:id], row[:name], row[:description], row[:unit_price], row[:created_at], row[:updated_at], row[:merchant_id])
    end
  end

  def create_item(id, name, description, unit_price, created_at, updated_at, merchant_id)
    Struct::Item.new(id.to_i, name, description, BigDecimal.new("#{unit_price[0..-3]}.#{unit_price[-2..-1]}"), Time.parse(created_at), Time.parse(updated_at), merchant_id)
  end

  Struct.new("Item", :id, :name, :description, :unit_price, :created_at, :updated_at, :merchant_id)

end
