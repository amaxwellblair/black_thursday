require 'pry'

class Item
  attr_accessor :id, :name, :description, :unit_price, :created_at, :updated_at,
                :merchant_id, :unit_price_to_dollars, :merchant

  def initialize(args)
    @id = args[:id].to_i
    @name = args[:name]
    @description = args[:description]
    @unit_price = make_bigdecimal(args[:unit_price])
    @created_at = Time.parse(args[:created_at])
    @updated_at = Time.parse(args[:updated_at])
    @merchant_id = args[:merchant_id].to_i
    @unit_price_to_dollars = make_bigdecimal(args[:unit_price]).to_f
    @merchant = 0
  end

  def make_bigdecimal(unit_price)
    if unit_price.class == String
      BigDecimal.new("#{unit_price[0..-3]}.#{unit_price[-2..-1]}")
    else
      BigDecimal.new(unit_price)
    end
  end

  def inspect
    "#<#{self.class}>"
  end

end
