Rails.application.routes.draw do
  resources :categories
  resources :addresses
  resources :orders
  resources :services
  resources :artists
  resources :clients
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'static#index'
end
