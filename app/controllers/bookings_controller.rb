class BookingsController < ApplicationController
  def index
    puts session[:flights]
    @flights = session[:flights]
  end

  def show
    @amount = params[:amount]
  end

  def failure
    @message = flash[:alert]
  end
end