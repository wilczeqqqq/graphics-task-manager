Rails.application.routes.draw do
  root to: proc { [404, {}, ["Not found."]] }

  get '/api' => redirect('/swagger/dist/index.html?url=/api-docs.json')

  namespace 'v1' do
    root to: proc { [404, {}, ["Not found."]] }

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
