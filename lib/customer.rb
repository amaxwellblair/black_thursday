require 'pry'

class Customer
  attr_accessor :id, :first_name, :last_name, :created_at, :updated_at,
                :merchants

  def initialize(args)
    @id = args[:id].to_i
    @first_name = args[:first_name]
    @last_name = args[:last_name]
    @created_at = Time.parse(args[:created_at])
    @updated_at = Time.parse(args[:updated_at])
    @merchants = []
  end

  def inspect
    "#<#{self.class}>"
  end

end
