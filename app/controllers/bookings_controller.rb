class BookingsController < ApplicationController
  def new
    @cost = params[:cost]
  end
end