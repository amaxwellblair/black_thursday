require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/repository'

class DoubleDown
  attr_reader :fake

  def initialize
    @fake = "BHAB"
  end

end

class RepositoryTest < Minitest::Test
  attr_reader :repo

  def setup
    @repo = Repository.new
  end

  def test_internal_list
    assert_equal [], repo.internal_list
  end

  def test_list_insert
    repo.list_insert{DoubleDown.new}
    assert_equal "BHAB", repo.internal_list.first.fake
  end

  def test_all
    repo.list_insert{DoubleDown.new}
    assert_equal "BHAB", repo.all.first.fake
  end

  def test_repo_find_by
    repo.list_insert{DoubleDown.new}
    assert_equal "BHAB", repo.find_by("fake", "BHAB").fake
  end

  def test_repo_find_all_by
    repo.list_insert{DoubleDown.new}
    assert_equal "BHAB", repo.find_all_by("fake", "BHAB").first.fake
  end

end
