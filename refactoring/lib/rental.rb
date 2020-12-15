class Rental
  attr_reader :movie, :days_rented
  
  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end
end