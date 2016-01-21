require 'pry'

class Item
  attr_accessor :id, :name, :description, :unit_price, :created_at, :updated_at,
                :merchant_id, :unit_price_to_dollars, :merchant

  def initialize(args)
    @id = args.fetch(:id, 0).to_i
    @name = args.fetch(:name, "")
    @description = args.fetch(:description, 0)
    @unit_price = make_bigdecimal(args.fetch(:unit_price, 0))
    @created_at = Time.parse(args.fetch(:created_at, "12/1/2020"))
    @updated_at = Time.parse(args.fetch(:updated_at, "12/1/2020"))
    @merchant_id = args.fetch(:merchant_id, 0).to_i
    @unit_price_to_dollars = make_unit_price_to_dollars(args.fetch(:unit_price, 0)).to_f
    @merchant = 0
  end

  def make_unit_price_to_dollars(string)
    make_bigdecimal("#{string[0..-3]}.#{string[-2..-1]}")
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
