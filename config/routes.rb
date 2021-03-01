Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'
  post 'home/cart', to: 'home#cart', as: 'cart'
  post 'home/clear_cart', to: 'home#clear_cart', as: 'clear_cart'
  post '/order', to: 'home#order'

  get 'bookings/index', to: 'bookings#index'
  get 'bookings/show/:amount', to: 'bookings#show', as: 'bookings_show'
  get 'bookings/checkout', to: 'bookings#checkout', as: 'checkout'
  get 'bookings/failure', to: 'bookings#failure'
  post 'bookings/save', to: 'bookings#save_payment_method', as: 'save_payment_method'

  get 'payment_methods/index', to: 'payment_methods_#index'
end
