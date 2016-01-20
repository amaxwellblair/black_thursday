require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'time'
require './lib/customer_repository'


class CustomerRepositoryTest < Minitest::Test
  attr_reader :customer_repo, :customer_1, :customer_2

  def setup
    @customer_repo = CustomerRepository.new
    @customer_1 = {id: 1, first_name: "John", last_name: "Smith", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
    @customer_2 = {id: 2, first_name: "Johnny", last_name: "Granny Smith", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
  end

  def test_customer_repo_exists
    assert customer_repo
  end

  def test_create_customer
    assert_equal Customer, customer_repo.create_customer(customer_1).class
  end

  def test_list_insert
    customer_repo.list_insert(customer_1)
    assert_equal "John", customer_repo.internal_list.first.first_name
  end

  def test_list_insert_time
    customer_repo.list_insert(customer_1)
    assert_equal Time.parse("2016-01-11 20:56:57 UTC"), customer_repo.internal_list.first.created_at
  end

  def test_customer_return_all
    customer_repo.list_insert(customer_1)
    assert_equal "John", customer_repo.all.first.first_name
  end

  def test_customer_return_find_by_id
    customer_repo.list_insert(customer_1)
    assert_equal "John", customer_repo.find_by_id(1).first_name
  end

  def test_customer_return_find_all_by_first_name
    customer_repo.list_insert(customer_1)
    customer_repo.list_insert(customer_2)
    ids = customer_repo.find_all_by_first_name("Jo").map do |customer|
      customer.id
    end
    assert_equal [1, 2], ids
  end

  def test_customer_return_find_all_by_last_name
    customer_repo.list_insert(customer_1)
    customer_repo.list_insert(customer_2)
    ids = customer_repo.find_all_by_last_name("Smith").map do |customer|
      customer.id
    end
    assert_equal [1, 2], ids
  end

  def test_load_data
    customer_repo.load_data("./data/customers.csv")
    expected = "Joey"
    assert_equal expected, customer_repo.find_by_id(1).first_name
  end

end
