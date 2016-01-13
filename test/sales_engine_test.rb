require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/sales_engine'


class SalesEngineTest < Minitest::Test
  attr_accessor :cash_register

  def setup
    path_hash = {:items => "./data/items.csv",
                 :merchants => "./data/merchants.csv" }
    @cash_register = SalesEngine.from_csv(path_hash)
  end

  def test_merchant_relation
    items = cash_register.merchants.all.first.items
    names = items.map { |item| item.name }
    assert_equal ["Vogue Paris Original Givenchy 2307", "Butterick 4236 Bridal Accessories", "Vogue Patterns/Patron 9712"], names
  end

  def test_item_relation
    merchant = cash_register.items.all.first.merchant
    name = merchant.name
    assert_equal "jejum", name
  end

  def test_load_data
    refute cash_register.items.internal_list.empty?
    refute cash_register.merchants.internal_list.empty?
  end

  def test_load_items_correctly
    expected_name = "A Variety of Fragrance Oils for Oil Burners, Potpourri, Resins + More, Lavender, Patchouli, Nag Champa, Rose, Vanilla, White Linen, Angel"
    id = 263397163
    assert_equal expected_name, cash_register.items.find_by_id(id).name
  end

  def test_load_merchants_correctly
    assert_equal "Shopin1901", cash_register.merchants.find_by_id(12334105).name
  end

end
