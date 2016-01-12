require 'CSV'
require 'repository'
require 'pry'

class ItemRepository
  attr_reader :internal_list

  def initialize
    @internal_list = []
  end

  def load_data(file_extension)
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
       list_insert(row[:id].to_i, row[:name])
    end
  end

  def all
    internal_list
  end

  def find_by_id(id)
    internal_list.find{|merc| id == merc.id}
  end

  def find_by_name(name)
    internal_list.find{|merc| name.downcase == merc.name.downcase}
  end

  def find_all_by_name(substring)
    internal_list.find_all do |merc|
      /#{Regexp.quote(substring.downcase)}\S+/ =~ merc.name.downcase
    end
  end

  def list_insert(id, name, description, unit_price, created_at, updated_at, merchant_id)
    internal_list << create_item(id, name, description, unit_price, created_at, updated_at, merchant_id)
  end

  def create_item(id, name, description, unit_price, created_at, updated_at, merchant_id)
    Struct::Item.new(id, name, description, unit_price, created_at, updated_at, merchant_id)
  end

  Struct.new("Item", :id, :name, :description, :unit_price, :created_at, :updated_at, :merchant_id)

end
