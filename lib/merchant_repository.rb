require 'csv'
require 'pry'
require 'merchant'

class MerchantRepository
  attr_accessor :internal_list

  def initialize
    @internal_list = []
  end

  def all
    internal_list
  end

  def find_by_id(id)
    internal_list.find{|merc| id == merc.id}
  end

  def find_by_name(name)
    internal_list.find{|merc| name.downcase == merc.name.downcase}
  end

  def find_all_by_name(substring)
    internal_list.find_all do |merc|
      /#{Regexp.quote(substring.downcase)}\S*/ =~ merc.name.downcase
    end
  end

  def revenue(date)
    #fix or double check this when the spec harness comes in (how is date being passed in?)
    all_invoices = internal_list.map do |merc|
      merc.invoices.find_all do |invoice|
        date.strftime("%B %d, %Y") == invoice.created_at.strftime("%B %d, %Y")
      end
    end.flatten
    total_revenue(all_invoices)
  end

  def total_revenue(invoices)
    invoices.inject(0) do |sum, invoice|
      if invoice.paid_in_full?
        sum + invoice.total
      else
        sum
      end
    end
  end

  def most_revenue(number)
    internal_list.sort_by{|merc| merc.revenue}[0..(number - 1)]
  end

  def top_percent
  end

  def list_insert(args)
    internal_list << create_merchant(args)
  end

  def load_data(file_extension)
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
      list_insert(row.to_hash)
    end
  end

  def create_merchant(args)
    Merchant.new(args)
  end

end
