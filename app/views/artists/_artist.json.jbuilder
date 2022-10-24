json.extract! artist, :id, :login, :password, :full_name, :nickname, :login_status, :created_at, :updated_at
json.url artist_url(artist, format: :json)
