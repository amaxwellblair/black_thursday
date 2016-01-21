require 'simplecov'
SimpleCov.start
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
    assert_equal 349.56, @@accountant.average_average_price_per_merchant.to_f
  end

  def test_merchants_with_high_item_count
    names = @@accountant.merchants_with_high_item_count.map{|item| item.name}
    assert_equal 52, names.length
  end

  def test_golden_items
    items = @@accountant.golden_items
    assert_equal 5, items.length
    # assert_equal Item, items.class
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
    assert_equal ["Wednesday"], @@accountant.top_days_by_invoice_count
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

    assert invoice.is_paid_in_full?
    assert_equal 21067.77, expected
  end

  def test_single_merchant_revenue
    merchant = @@accountant.sales_engine.merchants.all.first
    assert_equal 73777.17, merchant.revenue.to_f
  end

  def test_merchants_revenue_on_a_specific_date
    assert_equal 21067.77, @@accountant.total_revenue_by_date(Time.parse("2009-02-07"))
  end

  def test_merchants_most_revenue_count
    assert_equal 5, @@accountant.top_revenue_earners(5).count
  end

  def test_merchants_most_revenue_count_name
    assert_equal "HoggardWoodworks", @@accountant.top_revenue_earners(5).first.name
  end

  def test_merchants_most_revenue_nothing_in_the_arguments
    assert_equal 20, @@accountant.top_revenue_earners.count
  end

  def test_merchants_with_pending_invoices
    assert_equal 467, @@accountant.merchants_with_pending_invoices.length
  end

  def test_merchants_with_one_item_in_their_items
    assert_equal 243, @@accountant.merchants_with_only_one_item.length
  end

  def test_merchants_with_only_one_item_in_inserted_month
    assert_equal 21, @@accountant.merchants_with_only_one_item_registered_in_month("March").length
  end

  def test_most_sold_item_for_merchant
    assert_equal "Gray Hollister Sweatpant Medium", @@accountant.most_sold_item_for_merchant(12336753).first.name
  end

  def test_best_item_for_merchant_returns_the_item_with_most_revenue
    assert_equal "knit baby yoda hat", @@accountant.best_item_for_merchant(12336753).name
  end


end
