require 'pry'
class Merchant
  attr_accessor :id, :name, :items, :invoices, :customers

  def initialize(args)
    @id = args[:id].to_i
    @name = args[:name]
    @merchant_id = args[:merchant_id].to_i
    @items = args[:items]
    @invoices = args[:invoices]
    @customers = args[:customers]
  end

  def revenue
    invoices.inject(0) do |sum, invoice|
      if invoice.paid_in_full?
        sum + invoice.total
      else
        sum
      end
    end
  end

end
