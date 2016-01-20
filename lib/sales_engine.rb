require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'
require 'bigdecimal'
require 'pry'

class SalesEngine
  attr_reader :items, :merchants, :invoices, :invoice_items, :transactions,
              :customers

  def initialize
    @items = ItemRepository.new
    @merchants = MerchantRepository.new
    @invoices = InvoiceRepository.new
    @invoice_items = InvoiceItemRepository.new
    @transactions = TransactionRepository.new
    @customers = CustomerRepository.new
  end

  def self.from_csv(path_hash)
    sales_engine = self.new
    sales_engine.items.load_data(path_hash[:items])
    sales_engine.merchants.load_data(path_hash[:merchants])
    sales_engine.invoices.load_data(path_hash[:invoices])
    sales_engine.invoice_items.load_data(path_hash[:invoice_items])
    sales_engine.transactions.load_data(path_hash[:transactions])
    sales_engine.customers.load_data(path_hash[:customers])
    sales_engine.relationships
    sales_engine
  end

  def relationships
    merchant_relation_to_item
    item_relation_to_merchant
    invoice_relation_to_merchant
    merchant_relation_to_invoice
    invoice_relation_to_item
    invoice_relation_to_transaction
    invoice_relation_to_customer
    transaction_relation_to_invoice
    merchant_relation_to_customers
    customer_relation_to_merchants
    invoice_relation_to_total
  end

  def merchant_relation_to_item
    merchants.internal_list.each do |merchant|
      merchant.items = items.find_all_by_merchant_id(merchant.id)
    end
  end

  def item_relation_to_merchant
    items.internal_list.each do |item|
      item.merchant = merchants.find_by_id(item.merchant_id)
    end
  end

  def invoice_relation_to_merchant
    invoices.internal_list.each do |invoice|
      invoice.merchant = merchants.find_by_id(invoice.merchant_id)
    end
  end

  def merchant_relation_to_invoice
    merchants.internal_list.each do |merchant|
      merchant.invoices = invoices.find_all_by_merchant_id(merchant.id)
    end
  end

  def invoice_relation_to_item
    invoice_gets_invoice_items.each do |invoice_items|
      next if invoice_items.empty?
      invoices.find_by_id(invoice_items.first.invoice_id).items =
      invoice_items.map do |invoice_item|
        items.find_by_id(invoice_item.item_id)
      end
    end
  end

  def invoice_gets_invoice_items
    invoices.internal_list.map do |invoice|
      invoice_items.find_all_by_invoice_id(invoice.id)
    end
  end

  def total_per_invoice
    invoice_gets_invoice_items.map do |invoice_items|
      invoice_items.inject(0) do |sum, invoice_item|
        sum + invoice_item.unit_price * invoice_item.quantity
      end
    end
  end

  def invoice_relation_to_total
    total = total_per_invoice
    invoices.all.each.with_index do |invoice, index|
      invoice.total = total[index]/100.0
    end
  end

  def invoice_relation_to_transaction
    invoices.internal_list.each do |invoice|
      invoice.transactions = transactions.find_all_by_invoice_id(invoice.id)
    end
  end

  def invoice_relation_to_customer
    invoices.internal_list.each do |invoice|
      invoice.customer = customers.find_by_id(invoice.customer_id)
    end
  end

  def transaction_relation_to_invoice
    transactions.internal_list.each do |transaction|
      transaction.invoice = invoices.find_by_id(transaction.invoice_id)
    end
  end

  def merchant_relation_to_customers
    merchants.internal_list.each do |merchant|
      merchant.customers = merchant.invoices.map do |invoice|
        customers.find_by_id(invoice.customer_id)
      end.uniq
    end
  end

  def customer_relation_to_merchants
    customers.internal_list.each do |customer|
      customer.merchants =
      invoices.find_all_by_customer_id(customer.id).map do |invoice|
        merchants.find_by_id(invoice.merchant_id)
      end
    end
  end

end
