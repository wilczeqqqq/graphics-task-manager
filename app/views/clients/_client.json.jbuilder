json.extract! client, :id, :login, :password, :full_name, :login_status, :created_at, :updated_at
json.url client_url(client, format: :json)
