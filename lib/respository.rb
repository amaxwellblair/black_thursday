require 'CSV'
require 'pry'

class Repository
  attr_reader :internal_list

  def initialize
    @internal_list = []
  end

  def repo_load_data(file_extension, &block)
    binding.pry
    data = CSV.open(file_extension, headers: true, header_converters: :symbol)
    data.each do |row|
       block.call(row)
    end
  end

  def all
    internal_list
  end

  def find_by(method_name, search_for)
    internal_list.find{|thing| search_for == thing.send(method_name)}
  end

  def find_all_by(method_name, search_for)
    internal_list.find_all{|thing| search_for == thing.send(method_name)}
  end

  def list_insert(&block)
    internal_list << block.call
  end

end
