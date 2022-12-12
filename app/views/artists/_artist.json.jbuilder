json.extract! artist, :id, :login, :password_digest, :nickname, :bio, :preferred_style, :token, :created_at, :updated_at
json.url artist_url(artist, format: :json)
