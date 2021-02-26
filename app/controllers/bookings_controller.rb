class BookingsController < ApplicationController
  def index
    puts session[:flights]
    @flights = session[:flights]
  end

  def show
    @amount = params[:amount]
  end
end