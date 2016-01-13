require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'time'
require './lib/item_repository'


class ItemRepositoryTest < Minitest::Test
  attr_reader :item_repo, :item_1, :item_2

  def setup
    @item_repo = ItemRepository.new
    @item_1 = {id: 1, name: "apple", description: "food", unit_price: "100", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC", merchant_id: 1}
    @item_2 = {id: 1, name: "apple pie", description: "fooding yummie", unit_price: "150", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC", merchant_id: 2}
  end

  def test_item_repo_exists
    assert item_repo
  end

  def test_create_item
    assert_equal ItemRepository::Struct::Item, item_repo.create_item(item_1).class
  end

  def test_list_insert_name
    item_repo.list_insert(item_1)
    assert_equal "apple", item_repo.internal_list.first.name
  end

  def test_list_insert_time
    item_repo.list_insert(item_1)
    assert_equal Time.parse("2016-01-11 20:56:57 UTC"), item_repo.internal_list.first.created_at
  end

  def test_list_insert_big_decimal
    item_repo.list_insert(item_1)
    assert_equal BigDecimal.new("1.00"), item_repo.internal_list.first.unit_price
  end

  def test_item_return_all
    item_repo.list_insert(item_1)
    assert_equal "apple", item_repo.all.first.name
  end

  def test_item_return_find_by_id
    item_repo.list_insert(item_1)
    assert_equal "apple", item_repo.find_by_id(1).name
  end

  def test_item_return_find_by_name
    item_repo.list_insert(item_1)
    assert_equal "apple", item_repo.find_by_name("apple").name
  end

  def test_item_return_find_all_with_description
    item_repo.list_insert(item_1)
    item_repo.list_insert(item_2)
    names = item_repo.find_all_with_description("foo").map do |item|
      item.name
    end
    assert_equal ["apple", "apple pie"], names
  end

  def test_item_return_find_all_by_price
    item_repo.list_insert(item_1)
    item_2[:unit_price] = "100"
    item_repo.list_insert(item_2)
    names = item_repo.find_all_by_price("100").map do |item|
      item.name
    end
    assert_equal ["apple", "apple pie"], names
  end

  def test_item_return_find_all_by_price_in_range
    item_repo.list_insert(item_1)
    item_2[:unit_price] = "150"
    item_repo.list_insert(item_2)
    names = item_repo.find_all_by_price_in_range(1..2).map do |item|
      item.name
    end
    assert_equal ["apple", "apple pie"], names
  end

  def test_item_return_find_all_by_merchant_id
    item_repo.list_insert(item_1)
    item_2[:merchant_id] = 1
    item_repo.list_insert(item_2)
    names = item_repo.find_all_by_merchant_id(1).map do |item|
      item.name
    end
    assert_equal ["apple", "apple pie"], names
  end

  def test_load_data
    item_repo.load_data("./data/items.csv")
    expected_name = "A Variety of Fragrance Oils for Oil Burners, Potpourri, Resins + More, Lavender, Patchouli, Nag Champa, Rose, Vanilla, White Linen, Angel"
    id = 263397163
    assert_equal expected_name, item_repo.find_by_id(id).name
  end

end
