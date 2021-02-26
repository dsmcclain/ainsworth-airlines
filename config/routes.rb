Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'
  get 'bookings/show/', to: 'bookings#index', as: 'checkout'
  post 'home/cart', to: 'home#cart', as: 'cart'
  post 'home/clear_cart', to: 'home#clear_cart', as: 'clear_cart'
  post '/purchase', to: 'home#purchase'
end
