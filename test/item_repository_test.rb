require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/item_repository'


class ItemRepositoryTest < Minitest::Test
  attr_reader :item_repo

  def setup
    skip
    @item_repo = ItemRepository.new
  end

  def test_item_repo_exists
    skip
    assert item_repo
  end

  def test_create_item
    skip
    assert_equal ItemRepository::Struct::Item, item_repo.create_item(1, "John Smith").class
  end

  def test_list_insert
    skip
    item_repo.list_insert(1, "John Smith")
    assert_equal "John Smith", item_repo.internal_list.first.name
  end

  def test_item_return_all
    skip
    item_repo.list_insert(1, "John Smith")
    assert_equal "John Smith", item_repo.all.first.name
  end

  def test_item_return_find_by_id
    skip
    item_repo.list_insert(1, "John Smith")
    assert_equal "John Smith", item_repo.find_by_id(1).name
  end

  def test_item_return_find_by_name
    skip
    item_repo.list_insert(1, "John Smith")
    assert_equal "John Smith", item_repo.find_by_name("John Smith").name
  end

  def test_item_return_find_all_by_name
    skip
    item_repo.list_insert(1, "John Smith")
    item_repo.list_insert(2, "Johnny Apple Seed")
    names = item_repo.find_all_by_name("Jo").map do |item|
      item.name
    end
    assert_equal ["John Smith", "Johnny Apple Seed"], names
  end

  def test_load_data
    skip
    item_repo.load_data("./data/items.csv")
    assert_equal "Schroeder-Jerde", item_repo.find_by_id(1).name
  end

end
