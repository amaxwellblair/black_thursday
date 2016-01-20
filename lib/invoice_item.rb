require 'bigdecimal'
require 'pry'

class InvoiceItem
  attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :created_at,
                :updated_at

  def initialize(args)
    @id = args[:id].to_i
    @item_id = args[:item_id].to_i
    @invoice_id = args[:invoice_id].to_i
    @quantity = args[:quantity].to_i
    @unit_price = make_bigdecimal(args[:unit_price])
    @created_at = Time.parse(args[:created_at])
    @updated_at = Time.parse(args[:updated_at])
  end

  def make_bigdecimal(unit_price)
    if unit_price.class == String
      BigDecimal.new("#{unit_price}")
    else
      BigDecimal.new(unit_price)
    end
  end

  def inspect
    "#<#{self.class}>"
  end

end
