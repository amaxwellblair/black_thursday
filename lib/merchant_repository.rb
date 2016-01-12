require 'CSV'
require 'repository'
require 'pry'

class MerchantRepository
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

  def list_insert(id, name)
    internal_list << create_merchant(id, name)
  end

  def create_merchant(id, name)
    Struct::Merchant.new(id, name)
  end

  Struct.new("Merchant", :id, :name)

end
