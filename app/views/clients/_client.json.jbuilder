json.extract! client, :id, :full_name, :email, :phone, :age, :created_at, :updated_at
json.url client_url(client, format: :json)
