json.extract! artist, :id, :login, :password, :nickname, :bio, :preferred_style, :token, :created_at, :updated_at
json.url artist_url(artist, format: :json)
