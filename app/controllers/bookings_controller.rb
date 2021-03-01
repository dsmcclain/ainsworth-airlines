class BookingsController < ApplicationController
  def index
    # passing a nil payment_method_token because I won't need it and I don't want
    # to spend time creating a different service class for this API call
    render json: Cashier.new(nil).list_transactions[:subject]
  end

  def show
    @amount = params[:amount]
    session[:flights] = []
  end

  def checkout
    @flights = session[:flights]
  end

  def failure
    @message = flash[:alert]
  end

  def save_payment_method
    response = Cashier.new(session[:pm_token]).retain
    response_body = response[:subject]['transaction']
    puts response[:subject]

    if response.errors?
      puts response.errors
      render :file => "#{Rails.root}/public/500.html", status: 500
    elsif response_body['succeeded']
      @digits = response_body['payment_method']['last_four_digits']
      @name = response_body['payment_method']['first_name'] + ' ' + response_body['payment_method']['last_name']
    else
      @message = response_body['message']
    end

    session[:pm_token] = nil
    render 'save'
  end
end