require 'CSV'
require 'sales_engine'
require 'bigdecimal'
require 'pry'

class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    total_items = sales_engine.merchants.all.inject(0) do |sum, merchant|
      sum + merchant.items.length
    end
    (total_items / sales_engine.merchants.all.length.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    avg = average_items_per_merchant
    total_difference = sales_engine.merchants.all.inject(0) do |sum, merchant|
      sum +=  (merchant.items.length - avg)**2
    end
    Math.sqrt(total_difference / (sales_engine.merchants.all.length - 1)).round(2)
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    total_price = total_item_price(merchant.items)
    BigDecimal.new("#{(total_price / merchant.items.length).round(2)}")
  end

  def total_item_price(items)
    items.inject(0) do |sum_i, item|
      sum_i + item.unit_price
    end
  end

  def average_price_per_merchant
    total_avg_price = sales_engine.merchants.all.inject(0) do |sum_m, merchant|
      items_price = total_item_price(merchant.items)
      sum_m + (items_price/merchant.items.length)
    end
    BigDecimal.new("#{(total_avg_price / sales_engine.merchants.all.length).round(2)}")
  end

  def item_price_standard_deviation
    avg_item_price = total_item_price(sales_engine.items.all) / sales_engine.items.all.length
    total_difference = sales_engine.items.all.inject(0) do |sum, item|
      sum +=  (item.unit_price - avg_item_price)**2
    end
    Math.sqrt(total_difference / (sales_engine.items.all.length - 1)).round(2)
  end

  def golden_items
    avg_item_price = total_item_price(sales_engine.items.all) / sales_engine.items.all.length
    std_item_price = item_price_standard_deviation
    sales_engine.items.all.find_all do |item|
      item.unit_price > (avg_item_price + 2*std_item_price)
    end
  end

end
