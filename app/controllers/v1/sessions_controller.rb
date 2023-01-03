module V1
  class SessionsController < ApplicationController

    swagger_controller :sessions, 'Session'

    # POST /login
    swagger_api :login do
      summary 'Returns a token'
      param :body, :body , :string, :required, "Request body"
    end
    def login
      artist = Artist.find_by_login(params[:login])
      if artist && artist.authenticate(params[:password])
        token = jwt_encode(artist_id: artist.id)
        render json: { "token": token }, status: :ok
      else
        render json: { "error": "incorrect credentials" }, status: :unauthorized
      end
    end
  end
end
