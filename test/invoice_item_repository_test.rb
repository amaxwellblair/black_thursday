require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'time'
require './lib/invoice_item_repository'


class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :invoice_item_repo, :invoice_item_1, :invoice_item_2

  def setup
    @invoice_item_repo = InvoiceItemRepository.new
    @invoice_item_1 = {id: 1, item_id: 2, invoice_id: 3, quantity: 4, unit_price: "20000", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
    @invoice_item_2 = {id: 5, item_id: 6, invoice_id: 7, quantity: 8, unit_price: "10000", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
  end

  def test_invoice_item_repo_exists
    assert invoice_item_repo
  end

  def test_create_invoice_item
    assert_equal InvoiceItemRepository::Struct::InvoiceItem, invoice_item_repo.create_invoice_item(invoice_item_1).class
  end

  def test_list_insert
    invoice_item_repo.list_insert(invoice_item_1)
    assert_equal 2, invoice_item_repo.internal_list.first.item_id
  end

  def test_list_insert_time
    invoice_item_repo.list_insert(invoice_item_1)
    assert_equal Time.parse("2016-01-11 20:56:57 UTC"), invoice_item_repo.internal_list.first.created_at
  end

  def test_list_insert_big_decimal
    invoice_item_repo.list_insert(invoice_item_1)
    assert_equal BigDecimal.new("200.00"), invoice_item_repo.internal_list.first.unit_price
  end

  def test_invoice_item_return_all
    invoice_item_repo.list_insert(invoice_item_1)
    assert_equal 2, invoice_item_repo.all.first.item_id
  end

  def test_invoice_item_return_find_by_id
    invoice_item_repo.list_insert(invoice_item_1)
    assert_equal 2, invoice_item_repo.find_by_id(1).item_id
  end

  def test_invoice_item_return_find_all_by_item_id
    invoice_item_repo.list_insert(invoice_item_1)
    invoice_item_2[:item_id] = 2
    invoice_item_repo.list_insert(invoice_item_2)
    ids = invoice_item_repo.find_all_by_item_id(2).map do |invoice_item|
      invoice_item.id
    end
    assert_equal [1, 5], ids
  end

  def test_invoice_item_return_find_all_by_invoice_id
    invoice_item_repo.list_insert(invoice_item_1)
    invoice_item_2[:invoice_id] = 3
    invoice_item_repo.list_insert(invoice_item_2)
    ids = invoice_item_repo.find_all_by_invoice_id(3).map do |invoice_item|
      invoice_item.id
    end
    assert_equal [1, 5], ids
  end

  def test_load_data
    invoice_item_repo.load_data("./data/invoice_items.csv")
    expected = 263454779
    id = 2
    assert_equal expected, invoice_item_repo.find_by_id(id).item_id
  end

end
