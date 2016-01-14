require 'csv'
require 'time'
require 'bigdecimal'
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

  def make_bigdecimal(unit_price)
    BigDecimal.new("#{unit_price[0..-3]}.#{unit_price[-2..-1]}")
  end

  def create_transaction(args)
    Struct::Transaction.new(args[:id].to_i, args[:invoice_id].to_i, args[:credit_card_number].to_i,
                     args[:credit_card_expiration_date].to_i,
                     args[:result],
                     Time.parse(args[:created_at]),
                     Time.parse(args[:updated_at]), nil)
  end

  Struct.new("Transaction", :id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at, :invoice)

end
