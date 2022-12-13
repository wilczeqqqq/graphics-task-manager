Rails.application.routes.draw do
  root 'static#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :categories
  resources :addresses
  resources :orders
  resources :services
  resources :artists
  resources :clients
  resources :sessions
end
