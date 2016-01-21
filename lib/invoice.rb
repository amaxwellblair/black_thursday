require 'pry'

class Invoice
  attr_accessor :id, :customer_id, :merchant_id, :status, :created_at,
                :updated_at, :merchant, :items, :transactions, :customer,
                :total

  def initialize(args)
    @id = args.fetch(:id, 0).to_i
    @customer_id = args.fetch(:customer_id, 0).to_i
    @merchant_id = args.fetch(:merchant_id, 0).to_i
    @status = args.fetch(:status, "iiii").to_sym
    @created_at = Time.parse(args.fetch(:created_at, "12/1/2020"))
    @updated_at = Time.parse(args.fetch(:updated_at, "12/1/2020"))
    @merchant = 0
    @items = []
    @transactions = args.fetch(:transactions, [])
    @customer = 0
    @total = args.fetch(:total, 0)
  end

  def is_paid_in_full?
    transactions.any?{|transaction| transaction.result == "success"}
  end

  def inspect
    "#<#{self.class}>"
  end

end
