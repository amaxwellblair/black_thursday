require 'csv'
require 'date'
require_relative 'sales_engine'
require 'pry'

class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    total_items = sales_engine.merchants.all.inject(0) do |sum, merchant|
      sum + merchant.items.length
    end
    (total_items / sales_engine.merchants.all.length.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    avg = average_items_per_merchant
    total_difference = sales_engine.merchants.all.inject(0) do |sum, merchant|
      sum +=  (merchant.items.length - avg)**2
    end
    Math.sqrt(total_difference / (sales_engine.merchants.all.length - 1)).round(2)
  end

  def merchants_with_high_item_count
    avg_item_count = average_items_per_merchant
    std_item_count = average_items_per_merchant_standard_deviation
    sales_engine.merchants.all.find_all do |merchant|
      merchant.items.count > (avg_item_count + std_item_count)
    end
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    total_price = total_item_price(merchant.items)
    BigDecimal.new("#{(total_price / merchant.items.length).round(2)}")
  end

  def total_item_price(items)
    items.inject(0) do |sum_i, item|
      sum_i + item.unit_price
    end
  end

  def average_average_price_per_merchant
    total_avg_price = sales_engine.merchants.all.inject(0) do |sum_m, merchant|
      items_price = total_item_price(merchant.items)
      if items_price == 0
        sum_m
      else
        sum_m + (items_price/merchant.items.length)
      end
    end
    BigDecimal.new("#{(total_avg_price / sales_engine.merchants.all.length).round(2)}")
  end

  def item_price_standard_deviation
    avg_item_price = total_item_price(sales_engine.items.all) / sales_engine.items.all.length
    total_difference = sales_engine.items.all.inject(0) do |sum, item|
      sum + (item.unit_price - avg_item_price)**2
    end
    Math.sqrt(total_difference / (sales_engine.items.all.length - 1)).round(2)
  end

  def golden_items
    avg_item_price = average_average_price_per_merchant
    std_item_price = item_price_standard_deviation
    sales_engine.items.all.find_all do |item|
      item.unit_price > (avg_item_price + 2*std_item_price)
    end
  end

  def average_invoices_per_merchant
    total_invoices = sales_engine.merchants.all.inject(0) do |sum, merchant|
      sum + merchant.invoices.length
    end
    (total_invoices / sales_engine.merchants.all.length.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    total_difference = sales_engine.merchants.all.inject(0) do |sum, merchant|
      sum + (merchant.invoices.length - avg)**2
    end
    Math.sqrt(total_difference / (sales_engine.merchants.all.length - 1)).round(2)
  end

  def top_merchants_by_invoice_count
    avg_invoice_count = average_invoices_per_merchant
    std_invoice_count = average_invoices_per_merchant_standard_deviation
    sales_engine.merchants.all.find_all do |merchant|
      merchant.invoices.length > (avg_invoice_count + 2*std_invoice_count)
    end
  end

  def bottom_merchants_by_invoice_count
    avg_invoice_count = average_invoices_per_merchant
    std_invoice_count = average_invoices_per_merchant_standard_deviation
    sales_engine.merchants.all.find_all do |merchant|
      merchant.invoices.length < (avg_invoice_count - 2*std_invoice_count)
    end
  end

  def average_invoices_per_day
    sales_engine.invoices.all.length / 7
  end

  def week_invoice_tally
    week_day_tallies = [0, 0, 0, 0, 0, 0, 0]
    sales_engine.invoices.all.each do |invoice|
      indices_of_weekday = invoice.created_at.wday
      week_day_tallies[indices_of_weekday] += 1
    end
    week_day_tallies
  end

  def average_invoices_per_day_standard_deviation
    avg = average_invoices_per_day
    tally = week_invoice_tally
    total_difference = tally.inject(0) do |sum, day|
      sum + (day - avg)**2
    end
    Math.sqrt(total_difference / (tally.length - 1)).round(2)
  end

  def top_days_by_invoice_count
    avg = average_invoices_per_day
    std = average_invoices_per_day_standard_deviation
    tally = week_invoice_tally
    day_indices = (0..6).find_all do |index|
      tally[index] > (avg + std)
    end
    index_to_day(day_indices)
  end

  def index_to_day(indices)
    indices.map do |index|
      Date::DAYNAMES[index]
    end
  end

  def invoice_status_tally
    tally = {:shipped => 0, :pending => 0, :returned => 0}
    sales_engine.invoices.all.each do |invoice|
      tally[invoice.status.to_sym] += 1 if !tally[invoice.status.to_sym].nil?
    end
    tally
  end

  def invoice_status(status)
    tally = invoice_status_tally
    tally_total = tally.values.inject(:+)
    ((tally[status].to_f / (tally_total))*100).round(2)
  end

  def total_revenue_by_date(date)
    all_invoices = sales_engine.merchants.internal_list.map do |merc|
      merc.invoices.find_all do |invoice|
        date.strftime("%B %d, %Y") == invoice.created_at.strftime("%B %d, %Y")
      end
    end.flatten
    total_revenue(all_invoices)
  end

  def total_revenue(invoices)
    invoices.inject(0) do |sum, invoice|
      if invoice.is_paid_in_full?
        sum + invoice.total
      else
        sum
      end
    end
  end

  def top_revenue_earners(number = nil)
    if number.nil?
      merchants_ranked_by_revenue[0..20 - 1]
    else
      merchants_ranked_by_revenue[0..number - 1]
    end
  end

  def top_percent(collection, percent)
    collection[0..(collection.length * percent).ceil - 1]
  end

  # def by_month(collection, month)
  #   collection.map do |merc|
  #     merc.invoices.find_all do |invoice|
  #       date.strftime("%B") == invoice.created_at.strftime("%B")
  #     end
  #   end.flatten
  # end

  def merchants_ranked_by_revenue
    sales_engine.merchants.all.sort_by do |merchant|
      -merchant.revenue
    end
  end

  def revenue_by_merchant(merchant_id)
    sales_engine.merchants.find_by_id(merchant_id).revenue
  end

  def top_buyers(number)
    customers_ranked_by_revenue[0..number-1]
  end

  def customers_ranked_by_revenue
    sales_engine.customers.all.sort_by do |customer|
      -total_revenue(sales_engine.invoices.find_all_by_customer_id(customer.id))
    end
  end

  def top_merchant_for_customer(customer_id)
    hash = sales_engine.invoices.find_all_by_customer_id(customer_id).group_by do |invoice|
      invoice.merchant
    end
    merc_arr = []
    invoice_arr = []
    hash.each do |merchant, invoices|
      merc_arr << merchant
      invoice_arr << invoices.inject(0){|sum, invoice| sum + invoice.items.length}
    end
    merc_arr.sort_by.with_index do |merc, index|
      -invoice_arr[index]
    end.first
  end

  def merchants_with_pending_invoices
    sales_engine.merchants.all.find_all do |merchant|
      merchant.invoices.any?{|invoice| invoice.status == :pending}
    end
  end

  def merchants_with_only_one_item
    sales_engine.merchants.all.find_all do |merchant|
      merchant.items.length == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.strftime("%B").downcase == month.downcase
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    merchant.items.sort_by do |item|
      -sales_engine.invoice_items.find_all_by_item_id(item.id).inject(0) do |sum, invoice_item|
        if sales_engine.invoices.find_by_id(invoice_item.invoice_id).is_paid_in_full?
          sum + invoice_item.quantity
        else
          sum
        end
      end
    end.first
  end

  def best_item_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    merchant.items.sort_by do |item|
      -sales_engine.invoice_items.find_all_by_item_id(item.id).inject(0) do |sum, invoice_item|
        if sales_engine.invoices.find_by_id(invoice_item.invoice_id).is_paid_in_full?
          sum + (invoice_item.quantity * invoice_item.unit_price)
        else
          sum
        end
      end
    end.first
  end
  # customers.internal_list.each do |customer|
  #   customer.merchants =
  #   invoices.find_all_by_customer_id(customer.id).map do |invoice|
  #     merchants.find_by_id(invoice.merchant_id)
  #   end
  # end

end
