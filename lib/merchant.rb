require 'pry'
require 'time'
class Merchant
  attr_accessor :id, :name, :created_at, :updated_at, :items, :invoices, :customers

  def initialize(args)
    @id = args[:id].to_i
    @name = args[:name]
    @merchant_id = args[:merchant_id].to_i
    @items = args[:items]
    @created_at = Time.parse(args[:created_at])
    @updated_at = Time.parse(args[:updated_at])
    @invoices = args[:invoices]
    @customers = args[:customers]
  end

  def revenue
    invoices.inject(0) do |sum, invoice|
      if invoice.is_paid_in_full?
        sum + invoice.total
      else
        sum
      end
    end
  end

  def inspect
    "#<#{self.class}>"
  end

end
