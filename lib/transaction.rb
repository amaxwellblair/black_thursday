require 'pry'

class Transaction
  attr_accessor :id, :invoice_id, :credit_card_number,
                :credit_card_expiration_date, :result, :created_at,
                :updated_at, :invoice

  def initialize(args)
    @id = args.fetch(:id, 0).to_i
    @invoice_id = args.fetch(:invoice_id, 0).to_i
    @credit_card_number = args.fetch(:credit_card_number, 0).to_i
    @credit_card_expiration_date = args.fetch(:credit_card_expiration_date, "0")
    @result = args.fetch(:result, "0")
    @created_at = Time.parse(args.fetch(:created_at, "12/1/2020"))
    @updated_at = Time.parse(args.fetch(:updated_at, "12/1/2020"))
    @invoice = 0
  end

  def inspect
    "#<#{self.class}>"
  end

end
