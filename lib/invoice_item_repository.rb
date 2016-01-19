require_relative 'invoice_item'
require 'csv'
require 'time'

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

  def create_invoice_item(args)
    InvoiceItem.new(args)
  end

  def inspect
    "#<#{self.class} #{@internal_list.size} rows>"
  end

end
