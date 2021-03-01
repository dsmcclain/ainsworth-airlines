class PaymentMethodsController < ApplicationController
  def index
    # passing a nil payment_method_token because I won't need it and I don't want
    # to spend time creating a different service class for this API call
    render json: Cashier.new(nil).list_payment_methods[:subject]
  end
end