Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'
  post 'home/cart', to: 'home#cart', as: 'cart'
  post 'home/clear_cart', to: 'home#clear_cart', as: 'clear_cart'
  post '/order', to: 'home#order'

  get 'bookings/index', to: 'bookings#index', as: 'checkout'
  get 'bookings/show/:amount', to: 'bookings#show', as: 'bookings_show'
  get 'bookings/failure', to: 'bookings#failure'
end
