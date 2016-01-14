require 'csv'
require 'bigdecimal'
require 'time'
require 'pry'

class InvoiceRepository
  attr_accessor :internal_list

  def initialize
    @internal_list = []
  end

  def all
    internal_list
  end

  def find_by_id(id)
    internal_list.find{|invoice| id == invoice.id}
  end

  def find_all_by_customer_id(customer_id)
    internal_list.find_all{|invoice| customer_id == invoice.customer_id}
  end

  def find_all_by_merchant_id(merchant_id)
    internal_list.find_all{|invoice| merchant_id == invoice.merchant_id}
  end

  def find_all_by_status(status)
    internal_list.find_all{|invoice| status == invoice.status}
  end

  def list_insert(args)
    internal_list << create_invoice(args)
  end

  def load_data(file_extension)
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
      list_insert(row.to_hash)
    end
  end

  def create_invoice(args)
    Struct::Invoice.new(args[:id].to_i, args[:customer_id].to_i,
                        args[:merchant_id].to_i, args[:status],
                        Time.parse(args[:created_at]),
                        Time.parse(args[:updated_at]),
                        nil, nil, nil, nil)
  end

  Struct.new("Invoice", :id, :customer_id, :merchant_id, :status, :created_at, :updated_at, :merchant, :items, :transactions, :customer)

end
