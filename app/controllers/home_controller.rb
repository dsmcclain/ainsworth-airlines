class HomeController < ApplicationController
  require 'net/http'
  require 'uri'

  CITIES = %w(Portland Seattle Denver Raliegh-Durham Chicago Dallas Tampa)

  def index
    @flights = generate_flights
  end

  def cart
    session[:flights] ||= []
    session[:flights] << params[:flight]
    puts session[:flights]
  end

  def clear_cart
    session[:flights] = []
  end

  def purchase
    pm_token = params[:payment_method_token]
    amount = (params[:amount] * 100).to_i
    response = Cashier.new(pm_token, amount).call

    puts response
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