require 'csv'
require 'time'
require 'bigdecimal'
require 'pry'

class InvoiceItemRepository
  attr_accessor :internal_list

  def initialize
    @internal_list = []
  end

  def all
    internal_list
  end

  def find_by_id(id)
    internal_list.find{|invoice_item| id == invoice_item.id}
  end

  def find_all_by_item_id(item_id)
    internal_list.find_all do |invoice_item|
      item_id == invoice_item.item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    internal_list.find_all do |invoice_item|
      invoice_id == invoice_item.invoice_id
    end
  end

  def list_insert(args_hash)
    internal_list << create_invoice_item(args_hash)
  end

  def load_data(file_extension)
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
       list_insert(row.to_hash)
    end
  end

  def make_bigdecimal(unit_price)
    BigDecimal.new("#{unit_price[0..-3]}.#{unit_price[-2..-1]}")
  end

  def create_invoice_item(args)
    Struct::InvoiceItem.new(args[:id].to_i, args[:item_id].to_i, args[:invoice_id].to_i,
                     args[:quantity].to_i,
                     make_bigdecimal(args[:unit_price]),
                     Time.parse(args[:created_at]),
                     Time.parse(args[:updated_at]))
  end

  Struct.new("InvoiceItem", :id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at)

end
