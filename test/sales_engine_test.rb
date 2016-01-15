require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/sales_engine'


class SalesEngineTest < Minitest::Test

  @path_hash = {:items => "./data/items.csv",
               :merchants => "./data/merchants.csv",
               :invoices => "./data/invoices.csv",
               :invoice_items => "./data/invoice_items.csv",
               :transactions => "./data/transactions.csv",
               :customers => "./data/customers.csv"}
  @@cash_register = SalesEngine.from_csv(@path_hash)

  def test_load_data
    refute @@cash_register.items.internal_list.empty?
    refute @@cash_register.merchants.internal_list.empty?
    refute @@cash_register.invoices.internal_list.empty?
    refute @@cash_register.invoice_items.internal_list.empty?
    refute @@cash_register.transactions.internal_list.empty?
    refute @@cash_register.customers.internal_list.empty?
  end

  def test_load_items_correctly
    expected_name = "A Variety of Fragrance Oils for Oil Burners, Potpourri, Resins + More, Lavender, Patchouli, Nag Champa, Rose, Vanilla, White Linen, Angel"
    id = 263397163
    assert_equal expected_name, @@cash_register.items.find_by_id(id).name
  end

  def test_load_merchants_correctly
    assert_equal "Shopin1901", @@cash_register.merchants.find_by_id(12334105).name
  end

  def test_load_invoices_correctly
    expected_merc_id = 12335938
    id = 1
    assert_equal expected_merc_id, @@cash_register.invoices.find_by_id(id).merchant_id
  end

  def test_load_invoice_items_correctly
    expected = 263454779
    id = 2
    assert_equal expected, @@cash_register.invoice_items.find_by_id(id).item_id
  end

  def test_load_transactions_correctly
    expected = 4068631943231473
    assert_equal expected, @@cash_register.transactions.find_by_id(1).credit_card_number
  end

  def test_load_customers_correctly
    expected = "Joey"
    assert_equal expected, @@cash_register.customers.find_by_id(1).first_name
  end

  def test_merchant_relation_item
    items = @@cash_register.merchants.all.first.items
    names = items.map { |item| item.name }
    assert_equal ["Vogue Paris Original Givenchy 2307", "Butterick 4236 Bridal Accessories", "Vogue Patterns/Patron 9712"], names
  end

  def test_item_relation_merchant
    merchant = @@cash_register.items.all.first.merchant
    name = merchant.name
    assert_equal "jejum", name
  end

  def test_invoice_relation_merchant
    merchant = @@cash_register.invoices.all.first.merchant
    name = merchant.name
    assert_equal "IanLudiBoards", name
  end

  def test_merchant_relation_invoice
    invoices = @@cash_register.merchants.all.first.invoices
    ids = invoices.map { |invoice| invoice.id }
    assert_equal [74, 139, 273, 1195, 1372, 1383, 2629, 3248, 3485, 4227], ids
  end

  def test_invoice_relation_to_item
    invoice = @@cash_register.invoices.all.first
    assert_equal "Catnip Pillow / Cat Toy Containing Strong Dried CATNIP", invoice.items.first.name
  end

  def test_invoice_relation_to_transaction
    invoice = @@cash_register.invoices.all.first
    numbers = invoice.transactions.map do |transaction|
      transaction.credit_card_number
    end
    assert_equal [4306389908591848, 4880303970900271], numbers
  end

  def test_invoice_relation_to_customers
    invoice = @@cash_register.invoices.all.first
    assert_equal "Joey", invoice.customer.first_name
  end

  def test_transaction_relation_to_invoice
    transaction = @@cash_register.transactions.all.first
    assert_equal 12334633, transaction.invoice.merchant_id
  end

  def test_merchant_relation_to_customers
    merchant = @@cash_register.merchants.all.first
    names = merchant.customers.map do |customer|
      customer.first_name
    end
    assert_equal "Casimer", names.first
  end

  def test_customer_relation_to_merchants
    customer = @@cash_register.customers.all.first
    names = customer.merchants.map do |merchant|
      merchant.name
    end
    assert_equal "IanLudiBoards", names.first
  end

  def test_invoice_paid_in_full_true
    invoice = @@cash_register.invoices.all.first
    assert_equal true, invoice.paid_in_full?
  end

  def test_invoice_paid_in_full_false
    invoice = @@cash_register.invoices.find_by_id(1840)
    assert_equal false, invoice.paid_in_full?
  end

  def test_invoice_total
    invoice = @@cash_register.invoices.internal_list.first
    assert_equal 2562.44, invoice.total.to_f.round(2)
  end

  def test_single_merchant_revenue
    merchant = @@cash_register.merchants.all.first
    assert_equal 4180.94, merchant.revenue
  end

  def test_merchants_revenue_on_a_specific_date
    assert_equal 2562.44, @@cash_register.merchants.revenue(Time.parse("2009-02-07")).to_f
  end

  def test_merchants_most_revenue_count
    skip
    assert_equal 5, @@cash_register.merchants.most_revenue(5).count
  end

  def test_merchants_most_revenue_count_name
    skip
    assert_equal "name", @@cash_register.merchants.most_revenue(5).first.name
  end

  def test_merchants_most_revenue_nothing_in_the_arguments
    skip
    assert_equal 1, @@cash_register.merchants.most_revenue.count
  end

  def test_merchants_top_percentile
    skip
    assert_equal 3, @@cash_register.merchants.all.in_percentile.count
  end

  def test_merchants_top_percent
    skip
    assert_equal 3, @@cash_register.merchants.all.top_percent.count
  end

  def test_merchants_by_month
    skip
    assert_equal 5, @@cash_register.merchants.most_revenue.by_month("January").length
  end

end
