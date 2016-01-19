require 'pry'

class Invoice
  attr_accessor :id, :customer_id, :merchant_id, :status, :created_at,
                :updated_at, :merchant, :items, :transactions, :customer,
                :total

  def initialize(args)
    @id = args[:id].to_i
    @customer_id = args[:customer_id].to_i
    @merchant_id = args[:merchant_id].to_i
    @status = args[:status].to_sym
    @created_at = Time.parse(args[:created_at])
    @updated_at = Time.parse(args[:updated_at])
    @merchant = 0
    @items = []
    @transactions = []
    @customer = 0
  end

  def is_paid_in_full?
    transactions.any?{|transaction| transaction.result == "success"}
  end

  def inspect
    "#<#{self.class}>"
  end

end
