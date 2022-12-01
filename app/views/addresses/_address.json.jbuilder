json.extract! address, :id, :client_id, :address_line_1, :address_line_2, :postal_code, :city, :country, :created_at, :updated_at
json.url address_url(address, format: :json)
