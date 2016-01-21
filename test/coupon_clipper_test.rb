require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require 'pry'
require './lib/sales_engine'
require './lib/sales_analyst'


class CouponClipperTest < Minitest::Test

  @path_hash = {:items => "./data/items.csv",
               :merchants => "./data/merchants.csv",
               :invoices => "./data/invoices.csv",
               :invoice_items => "./data/invoice_items.csv",
               :transactions => "./data/transactions.csv",
               :customers => "./data/customers.csv"}
  @cash_register = SalesEngine.from_csv(@path_hash)
  @@accountant = SalesAnalyst.new(@cash_register)

  @@accountant.sales_engine.items.list_insert({id: 999999, name: "this thing", unit_price: "1000"})
  @@transaction = [@@accountant.sales_engine.transactions.create_transaction({id: 444444, result: "success"})]
  @@accountant.sales_engine.invoice_items.list_insert({id: 133769420, unit_price: "500", item_id: 999999, invoice_id: 6666666, quantity: 1})
  @@accountant.sales_engine.invoices.list_insert({id: 6666666, transactions: @@transaction, total: 500})

  def test_find_sale_discount_single_sale
    assert_equal -0.5, @@accountant.find_single_sale_discount(133769420)
  end

  def test_sticker_price
    assert_equal 1000, @@accountant.invoice_sticker_revenue(6666666)
  end

  def test_find_invoice_discount
    assert_equal -0.50, @@accountant.find_invoice_discount(6666666)
  end

  def test_merchant_average_discount
    assert_equal -0.48, @@accountant.merchant_average_discount(12334105)
  end

  def test_merchant_average_average_discount
    assert_equal -0.48, @@accountant.merchants_average_average_discount
  end

end
