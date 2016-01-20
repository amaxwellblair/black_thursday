require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'time'
require './lib/invoice_repository'


class InvoiceRepositoryTest < Minitest::Test
  attr_reader :invoice_repo, :invoice_1, :invoice_2

  def setup
    @invoice_repo = InvoiceRepository.new
    @invoice_1 = {id: 1, customer_id: 2, merchant_id: 3, status: "pending", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
    @invoice_2 = {id: 4, customer_id: 5, merchant_id: 6, status: "pending", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
    # id,customer_id,merchant_id,status,created_at,updated_at
  end

  def test_invoice_exists
    assert invoice_repo
  end

  def test_list_insert
    invoice_repo.list_insert(invoice_1)
    assert_equal 1, invoice_repo.internal_list.first.id
  end

  def test_invoice_all
    invoice_repo.list_insert(invoice_1)
    assert_equal 1, invoice_repo.all.first.id
  end

  def test_find_by_id
    invoice_repo.list_insert(invoice_1)
    assert_equal 2, invoice_repo.find_by_id(1).customer_id
  end

  def test_find_all_by_customer_id
    invoice_2[:customer_id] = 2
    invoice_repo.list_insert(invoice_1)
    invoice_repo.list_insert(invoice_2)
    ids = invoice_repo.find_all_by_customer_id(2).map{|invoice| invoice.id}
    assert_equal [1, 4], ids
  end

  def test_find_all_by_merchant_id
    invoice_2[:merchant_id] = 3
    invoice_repo.list_insert(invoice_1)
    invoice_repo.list_insert(invoice_2)
    ids = invoice_repo.find_all_by_merchant_id(3).map{|invoice| invoice.id}
    assert_equal [1, 4], ids
  end

  def test_find_all_by_status
    invoice_repo.list_insert(invoice_1)
    invoice_repo.list_insert(invoice_2)
    ids = invoice_repo.find_all_by_status(:pending).map{|invoice| invoice.id}
    assert_equal [1, 4], ids
  end

  def test_load_data
    invoice_repo.load_data("./data/invoices.csv")
    expected_merc_id = 12335938
    id = 1
    assert_equal expected_merc_id, invoice_repo.find_by_id(id).merchant_id
  end

end
