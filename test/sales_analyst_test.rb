require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require 'pry'
require './lib/sales_engine'
require './lib/sales_analyst'


class SalesAnalystTest < Minitest::Test

  @path_hash = {:items => "./data/items.csv",
               :merchants => "./data/merchants.csv",
               :invoices => "./data/invoices.csv"}
  @cash_register = SalesEngine.from_csv(@path_hash)
  @@accountant = SalesAnalyst.new(@cash_register)

  def test_sales_analysts_exists
    assert @@accountant
  end

  def test_avg_item_per_merchant
    assert_equal 2.87, @@accountant.average_items_per_merchant
  end

  def test_std_item_per_merchant
    assert_equal 3.26, @@accountant.average_items_per_merchant_standard_deviation
  end

  def test_average_item_price_for_merchant
    assert_equal 16.66, @@accountant.average_item_price_for_merchant(12334105).to_f
  end

  def test_average_item_price_for_merchant_big_decimal_check
    assert_equal BigDecimal, @@accountant.average_item_price_for_merchant(12334105).class
  end

  def test_average_price_per_merchant_for_all_merchants
    assert_equal 349.42, @@accountant.average_price_per_merchant.to_f
  end

  def test_merchants_with_low_item_count
    names = @@accountant.merchants_with_low_item_count.map{|item| item.name}
    assert_equal 0, names.length
  end

  def test_golden_items
    names = @@accountant.golden_items.map{|item| item.name}
    assert_equal 5, names.length
  end

  def test_avg_invoice_per_merchant
    assert_equal 10.47, @@accountant.average_invoices_per_merchant
  end

  def test_avg_invoice_per_merchant_std
    assert_equal 3.32, @@accountant.average_invoices_per_merchant_standard_deviation
  end

  def test_top_merchants_by_invoice_count
    assert_equal 12, @@accountant.top_merchants_by_invoice_count.length
  end

  def test_bottom_merchants_by_invoice_count
    assert_equal 5, @@accountant.bottom_merchants_by_invoice_count.length
  end

  def test_week_day_tally
    assert_equal [708, 696, 692, 741, 718, 701, 729], @@accountant.week_invoice_tally
  end

  def test_top_days_by_invoice_count
    assert_equal [], @@accountant.top_days_by_invoice_count
  end

  def test_invoice_tally
    expected = {:shipped=>2839, :pending=>1473}
    assert_equal expected, @@accountant.invoice_status_tally
  end

  def test_percentage_of_invoices_at_status
    assert_equal 34.16, @@accountant.invoice_status(:pending)
    assert_equal 65.84, @@accountant.invoice_status(:shipped)
  end
end
