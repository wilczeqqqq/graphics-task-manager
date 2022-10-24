json.extract! order, :id, :client_id, :artist_id, :service_id, :order_status, :created_at, :updated_at
json.url order_url(order, format: :json)
