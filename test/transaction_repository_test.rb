require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'time'
require './lib/transaction_repository'


class TransactionRepositoryTest < Minitest::Test
  attr_reader :transaction_repo, :transaction_1, :transaction_2

  def setup
    @transaction_repo = TransactionRepository.new
    @transaction_1 = {id: 1, invoice_id: 2, credit_card_number: 3, credit_card_expiration_date: 4, result: "success", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
    @transaction_2 = {id: 5, invoice_id: 6, credit_card_number: 7, credit_card_expiration_date: 8, result: "success", created_at: "2016-01-11 20:56:57 UTC", updated_at: "2016-01-11 20:56:57 UTC"}
  end

  def test_transaction_repo_exists
    assert transaction_repo
  end

  def test_create_transaction
    assert_equal Transaction, transaction_repo.create_transaction(transaction_1).class
  end

  def test_list_insert
    transaction_repo.list_insert(transaction_1)
    assert_equal 2, transaction_repo.internal_list.first.invoice_id
  end

  def test_list_insert_time
    transaction_repo.list_insert(transaction_1)
    assert_equal Time.parse("2016-01-11 20:56:57 UTC"), transaction_repo.internal_list.first.created_at
  end

  def test_transaction_return_all
    transaction_repo.list_insert(transaction_1)
    assert_equal 2, transaction_repo.all.first.invoice_id
  end

  def test_transaction_return_find_by_id
    transaction_repo.list_insert(transaction_1)
    assert_equal 2, transaction_repo.find_by_id(1).invoice_id
  end

  def test_transaction_return_find_all_by_invoice_id
    transaction_repo.list_insert(transaction_1)
    transaction_2[:invoice_id] = 2
    transaction_repo.list_insert(transaction_2)
    ids = transaction_repo.find_all_by_invoice_id(2).map do |transaction|
      transaction.id
    end
    assert_equal [1, 5], ids
  end

  def test_transaction_return_find_all_by_credit_card_number
    transaction_repo.list_insert(transaction_1)
    transaction_2[:credit_card_number] = 3
    transaction_repo.list_insert(transaction_2)
    ids = transaction_repo.find_all_by_credit_card_number(3).map do |transaction|
      transaction.id
    end
    assert_equal [1, 5], ids
  end

  def test_transaction_return_find_all_by_result
    transaction_repo.list_insert(transaction_1)
    transaction_repo.list_insert(transaction_2)
    ids = transaction_repo.find_all_by_result("success").map do |transaction|
      transaction.id
    end
    assert_equal [1, 5], ids
  end

  def test_load_data
    transaction_repo.load_data("./data/transactions.csv")
    expected = 4068631943231473
    assert_equal expected, transaction_repo.find_by_id(1).credit_card_number
  end

end
