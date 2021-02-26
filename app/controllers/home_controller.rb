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
    amount = (params[:amount].to_f * 100).to_i
    response = Cashier.new(pm_token, amount).call

    if response.errors?
      puts response.errors
      render :file => "#{Rails.root}/public/500.html",  status: 500
    elsif response[:subject]['transaction']['succeeded']
      redirect_to bookings_show_path(params[:amount])
    else
      flash[:alert] = response[:subject]['transaction']['message']
      redirect_to bookings_failure_path
    end
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