require 'csv'
require 'time'
require_relative 'transaction'
require 'pry'

class TransactionRepository
  attr_accessor :internal_list

  def initialize
    @internal_list = []
  end

  def all
    internal_list
  end

  def find_by_id(id)
    internal_list.find{|transaction| id == transaction.id}
  end

  def find_all_by_invoice_id(invoice_id)
    internal_list.find_all do |transaction|
      invoice_id == transaction.invoice_id
    end
  end

  def find_all_by_credit_card_number(number)
    internal_list.find_all do |transaction|
      number == transaction.credit_card_number
    end
  end

  def find_all_by_result(number)
    internal_list.find_all do |transaction|
      number == transaction.result
    end
  end

  def list_insert(args_hash)
    internal_list << create_transaction(args_hash)
  end

  def load_data(file_extension)
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
       list_insert(row.to_hash)
    end
  end

  def create_transaction(args)
    Transaction.new(args)
  end

  def inspect
    "#<#{self.class} #{@internal_list.size} rows>"
  end

end
