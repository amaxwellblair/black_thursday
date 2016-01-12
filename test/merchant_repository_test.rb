require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/merchant_repository'


class MerchantRepositoryTest < Minitest::Test
  attr_reader :merc_repo

  def setup
    @merc_repo = MerchantRepository.new
  end

  def test_merc_repo_exists
    assert merc_repo
  end

  def test_create_merchant
    assert_equal MerchantRepository::Struct::Merchant, merc_repo.create_merchant(1, "John Smith").class
  end

  def test_list_insert
    merc_repo.list_insert(1, "John Smith")
    assert_equal "John Smith", merc_repo.internal_list.first.name
  end

  def test_merchant_return_all
    merc_repo.list_insert(1, "John Smith")
    assert_equal "John Smith", merc_repo.all.first.name
  end

  def test_merchant_return_find_by_id
    merc_repo.list_insert(1, "John Smith")
    assert_equal "John Smith", merc_repo.find_by_id(1).name
  end

  def test_merchant_return_find_by_name
    merc_repo.list_insert(1, "John Smith")
    assert_equal "John Smith", merc_repo.find_by_name("John Smith").name
  end

  def test_merchant_return_find_all_by_name
    merc_repo.list_insert(1, "John Smith")
    merc_repo.list_insert(2, "Johnny Apple Seed")
    names = merc_repo.find_all_by_name("Jo").map do |merchant|
      merchant.name
    end
    assert_equal ["John Smith", "Johnny Apple Seed"], names
  end

  def test_load_data
    merc_repo.load_data("./data/merchants.csv")
    assert_equal "Schroeder-Jerde", merc_repo.find_by_id(1).name
  end

end
