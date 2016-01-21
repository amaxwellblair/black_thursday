require 'bigdecimal'
require 'pry'

class InvoiceItem
  attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :created_at,
                :updated_at

  def initialize(args)
    @id = args.fetch(:id, 0).to_i
    @item_id = args.fetch(:item_id, 0).to_i
    @invoice_id = args.fetch(:invoice_id, 0).to_i
    @quantity = args.fetch(:quantity, 0).to_i
    @unit_price = make_bigdecimal(args.fetch(:unit_price, 0))
    @created_at = Time.parse(args.fetch(:created_at, "12/1/2020"))
    @updated_at = Time.parse(args.fetch(:updated_at, "12/1/2020"))
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
