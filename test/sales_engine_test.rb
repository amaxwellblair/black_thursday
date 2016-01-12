require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'time'
require './lib/sales_engine'


class SalesEngineTest < Minitest::Test

  def test_cash_register_exists
    assert cash_register
  end

  def test_load_data
    path_hash = {:items => "./data/items.csv",
                 :merchants => "./data/merchants.csv" }

    cash_register = SalesEngine.from_csv(path_hash)

    refute cash_register.items.internal_list.empty?
    refute cash_register.merchants.internal_list.empty?
  end

  def test_load_items_correctly
    path_hash = {:items => "./data/items.csv",
                 :merchants => "./data/merchants.csv" }
    expected_name = "A Variety of Fragrance Oils for Oil Burners, Potpourri, Resins + More, Lavender, Patchouli, Nag Champa, Rose, Vanilla, White Linen, Angel"
    id = 263397163

    cash_register = SalesEngine.from_csv(path_hash)

    assert_equal expected_name, cash_register.items.find_by_id(id).name
  end

  def test_load_merchants_correctly
    path_hash = {:items => "./data/items.csv",
                 :merchants => "./data/merchants.csv" }

    cash_register = SalesEngine.from_csv(path_hash)

    assert_equal "Shopin1901", cash_register.merchants.find_by_id(12334105).name
  end

end
