require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'time'
require './lib/customer_repository'


class CustomerRepositoryTest < Minitest::Test
  attr_reader :customer_repo, :customer_1, :customer_2

  def setup
    @customer_repo = CustomerRepository.new
    @customer_1 = {id: 1, invoice_id: 2, credit_card_number: 3, credit_card_expiration_date: 4, result: "success", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
    @customer_2 = {id: 5, invoice_id: 6, credit_card_number: 7, credit_card_expiration_date: 8, result: "success", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
  end

  def test_customer_repo_exists
    assert customer_repo
  end

  def test_create_customer
    assert_equal CustomerRepository::Struct::Transaction, customer_repo.create_customer(customer_1).class
  end

  def test_list_insert_name
    customer_repo.list_insert(customer_1)
    assert_equal 2, customer_repo.internal_list.first.invoice_id
  end

  def test_list_insert_time
    customer_repo.list_insert(customer_1)
    assert_equal Time.parse("2016-01-11 20:56:57 UTC"), customer_repo.internal_list.first.created_at
  end

  def test_customer_return_all
    customer_repo.list_insert(customer_1)
    assert_equal 2, customer_repo.all.first.invoice_id
  end

  def test_customer_return_find_by_id
    customer_repo.list_insert(customer_1)
    assert_equal 2, customer_repo.find_by_id(1).invoice_id
  end

  def test_customer_return_find_all_by_invoice_id
    customer_repo.list_insert(customer_1)
    customer_2[:invoice_id] = 2
    customer_repo.list_insert(customer_2)
    ids = customer_repo.find_all_by_invoice_id(2).map do |customer|
      customer.id
    end
    assert_equal [1, 5], ids
  end

  def test_customer_return_find_all_by_credit_card_number
    customer_repo.list_insert(customer_1)
    customer_2[:credit_card_number] = 3
    customer_repo.list_insert(customer_2)
    ids = customer_repo.find_all_by_credit_card_number(3).map do |customer|
      customer.id
    end
    assert_equal [1, 5], ids
  end

  def test_customer_return_find_all_by_result
    customer_repo.list_insert(customer_1)
    customer_repo.list_insert(customer_2)
    ids = customer_repo.find_all_by_result("success").map do |customer|
      customer.id
    end
    assert_equal [1, 5], ids
  end

  def test_load_data
    customer_repo.load_data("./data/customers.csv")
    expected = 4068631943231473
    assert_equal expected, customer_repo.find_by_id(1).credit_card_number
  end

end
