require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require 'pry'
require './lib/sales_engine'
require './lib/sales_analyst'


class SalesAnalystTest < Minitest::Test

  @path_hash = {:items => "./data/items.csv",
               :merchants => "./data/merchants.csv",
               :invoices => "./data/invoices.csv",
               :invoice_items => "./data/invoice_items.csv",
               :transactions => "./data/transactions.csv",
               :customers => "./data/customers.csv"}
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
    assert_equal 349.56, @@accountant.average_price_per_merchant.to_f
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
    expected = {:shipped=>2839, :pending=>1473, :returned=>673}
    assert_equal expected, @@accountant.invoice_status_tally
  end

  def test_percentage_of_invoices_at_status
    assert_equal 29.55, @@accountant.invoice_status(:pending)
    assert_equal 56.95, @@accountant.invoice_status(:shipped)
    assert_equal 13.50, @@accountant.invoice_status(:returned)
  end

  def test_return_dollar_amount_invoice_total
    invoice = @@accountant.sales_engine.invoices.all.first
    expected = invoice.total.to_f

    assert invoice.paid_in_full?
    assert_equal 21067.77, expected
  end

  def test_single_merchant_revenue
    merchant = @@accountant.sales_engine.merchants.all.first
    assert_equal 73777.17, merchant.revenue.to_f
  end

  def test_merchants_revenue_on_a_specific_date
    assert_equal 21067.77, @@accountant.sales_engine.merchants.revenue(Time.parse("2009-02-07")).to_f
  end

  def test_merchants_most_revenue_count
    assert_equal 5, @@accountant.top_revenue_earners(5).count
  end

  def test_merchants_most_revenue_count_name
    assert_equal "HoggardWoodworks", @@accountant.top_revenue_earners(5).first.name
  end

  def test_merchants_most_revenue_nothing_in_the_arguments
    assert_equal 96, @@accountant.top_revenue_earners.count
  end

  def test_merchants_top_percent
    merchants = @@accountant.merchants_ranked_by_revenue
    assert_equal 96, @@accountant.top_percent(merchants, 0.20).count
  end

  def test_merchants_by_month
    skip
    merchants = @@accountant.merchants_ranked_by_revenue
    assert_equal 5, @@accountant.by_month(merchants, "January").length
  end

  def test_top_buyers
    assert_equal 10, @@accountant.top_buyers(10).length
  end

  def test_top_buyers
    assert_equal "Fisher", @@accountant.top_buyers(1).first.last_name
  end

  def test_top_merchant_for_customer
    assert_equal 12336753, @@accountant.top_merchant_for_customer(100).id
  end

  def test_one_time_buyers
    skip
    assert_equal 4, @@accountant.one_time_buyers
  end

end
