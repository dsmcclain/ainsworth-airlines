Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'
  get 'bookings/new/:cost', to: 'bookings#new', as: 'new_booking'
end
