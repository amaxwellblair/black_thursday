require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require 'pry'
require './lib/sales_engine'
require './lib/sales_analyst'


class SalesAnalystTest < Minitest::Test
  attr_accessor :accountant

  def setup
    path_hash = {:items => "./data/items.csv",
                 :merchants => "./data/merchants.csv" }
    cash_register = SalesEngine.from_csv(path_hash)
    @accountant = SalesAnalyst.new(cash_register)
  end

  def test_sales_analysts_exists
    assert accountant
  end

  def test_avg_item_per_merchant
    assert_equal 2.88, accountant.average_items_per_merchant
  end

  def test_std_item_per_merchant
    assert_equal 3.26, accountant.average_items_per_merchant_standard_deviation
  end

  def test_average_item_price_for_merchant
    assert_equal 16.66, accountant.average_item_price_for_merchant(12334105).to_f
  end

  def test_average_item_price_for_merchant_big_decimal_check
    assert_equal BigDecimal, accountant.average_item_price_for_merchant(12334105).class
  end

  def test_average_price_per_merchant_for_all_merchants
    skip
    assert_equal 10.50, accountant.average_price_per_merchant.to_f
  end

  def test_golden_items
    names = accountant.golden_items.map{|item| item.name}
    assert_equal 5, names.length
  end

end
