require 'minitest/autorun'
require_relative './test_helper'

class CustomerTest < Minitest::Test
  def test_it_exists
    customer = Customer.new("josh")
    movie = Movie.new("jaws 2", 0)
    rental = Rental.new(movie, 1)
    customer.add_rental(rental)
    assert_equal "josh", customer.name
    assert_equal 1, customer.rentals.count
    puts customer.statement
  end
  
end