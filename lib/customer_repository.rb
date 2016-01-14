require 'csv'
require 'time'
require 'bigdecimal'
require 'pry'

class CustomerRepository
  attr_accessor :internal_list

  def initialize
    @internal_list = []
  end

  def all
    internal_list
  end

  def find_by_id(id)
    internal_list.find{|customer| id == customer.id}
  end

  def find_all_by_first_name(substring)
    internal_list.find_all do |customer|
      /#{Regexp.quote(substring.downcase)}\S*/ =~ customer.first_name.downcase
    end
  end

  def find_all_by_last_name(substring)
    internal_list.find_all do |customer|
        /#{Regexp.quote(substring.downcase)}\S*/ =~ customer.last_name.downcase
    end
  end

  def list_insert(args)
    internal_list << create_customer(args)
  end

  def load_data(file_extension)
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
      list_insert(row.to_hash)
    end
  end

  def create_customer(args)
    Struct::Customer.new(args[:id].to_i, args[:first_name], args[:last_name],
                         Time.parse(args[:created_at]),
                         Time.parse(args[:updated_at]), args[:merchants])
  end

  Struct.new("Customer", :id, :first_name, :last_name, :created_at, :updated_at, :merchants)

end
