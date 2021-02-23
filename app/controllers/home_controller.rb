class HomeController < ApplicationController

  CITIES = %w(Portland Seattle Denver Raliegh-Durham Chicago Dallas Tampa)

  def index
    @flights = generate_flights
  end

  private

  def generate_flights
    arr = []
    6.times do
      departure = CITIES.sample
      arr << {
        departure: departure,
        destination: (CITIES - [departure]).sample,
        cost: rand(100..2000.1).truncate(2)
      }
    end
    arr
  end
end