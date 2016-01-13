require 'csv'
require 'pry'

class MerchantRepository
  attr_accessor :internal_list

  def initialize
    @internal_list = []
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

  def list_insert(args)
    internal_list << create_merchant(args)
  end

  def load_data(file_extension)
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
      list_insert(row.to_hash)
    end
  end

  def create_merchant(args)
    Struct::Merchant.new(args[:id].to_i, args[:name], args[:items], args[:invoices])
  end

  Struct.new("Merchant", :id, :name, :items, :invoices)

end
