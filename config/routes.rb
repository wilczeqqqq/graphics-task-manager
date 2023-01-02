Rails.application.routes.draw do
  namespace 'v1' do
    post '/login', to: 'sessions#login'

    get '/categories/:id/services', to: 'categories#list_services'
    get '/artists/:id/orders', to: 'artists#list_orders'
    get '/clients/:id/orders', to: 'clients#list_orders'

    resources :categories
    resources :orders
    resources :services
    resources :artists
    resources :clients do
      resources :addresses
    end
  end
end
