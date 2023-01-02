module V1
  class ArtistsController < ApplicationController
    before_action :authenticate_request, only: [:destroy, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block
    rescue_from JWT::DecodeError, with: :unauthorized

    # DONE

    # GET /artists or /artists.json
    def index
      artists = Artist.all
      render json: artists, only: [:id, :login, :password_digest, :nickname, :bio, :preferred_style], status: :ok
    end

    # GET /artists/1 or /artists/1.json
    def show
      artist = Artist.find(params[:id])
      render json: artist, only: [:id, :login, :password_digest, :nickname, :bio, :preferred_style], status: :ok
    end

    # POST /artists or /artists.json
    def create
      artist = Artist.new(artist_params)
      if artist.save
        render json: artist, only: [:id, :login, :password_digest, :nickname, :bio, :preferred_style], status: :created
      else
        render json: artist.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /artists/1 or /artists/1.json
    def update
      artist = Artist.find(params[:id])
      if artist.update(artist_params)
        render json: artist, only: [:id, :login, :password_digest, :nickname, :bio, :preferred_style], status: :created
      else
        render json: artist.errors, status: :unprocessable_entity
      end
    end

    # DELETE /artists/1 or /artists/1.json
    def destroy
      artist = Artist.find(params[:id])
      artist.destroy
      render json: { "success": "true" }, status: :ok
    end

    def list_orders
      artist = Artist.find(params[:id])
      render json: artist, only: [:id, :login], include:
        [orders: { only: [:id, :order_status, :notes], include:
          [client: { only: [:id, :full_name, :email, :phone, :age] }, service: { only: [:id, :name], include:
            [category: { only: [:id, :name] }]
          }]
        }], status: :ok
    end

    private

    # Only allow a list of trusted parameters through.
    def artist_params
      params.permit(:login, :password, :password_confirmation, :nickname, :bio, :preferred_style)
    end

    def not_found
      render json: { "error": "not found" }, status: :not_found
    end

    def foreign_key_block
      render json: { "error": "foreign key in use" }, status: :internal_server_error
    end

    def unauthorized
      render json: { "error": "unauthorized or token expired" }, status: :unauthorized
    end
  end
end
