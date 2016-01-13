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


end
