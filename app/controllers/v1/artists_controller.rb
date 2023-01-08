module V1
  class ArtistsController < ApplicationController
    before_action :authenticate_request, only: [:destroy, :update, :list_orders]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block
    rescue_from ActiveRecord::NotNullViolation, with: :not_null
    rescue_from JWT::DecodeError, with: :unauthorized

    swagger_controller :artists, 'Artists'

    # GET /artists
    swagger_api :index do
      summary 'Returns all artists\' details'
    end

    def index
      artists = Artist.all
      render json: artists, only: [:id, :login, :password_digest, :nickname, :bio, :preferred_style], status: :ok
    end

    # GET /artists/1
    swagger_api :show do
      summary 'Returns an artist\' details'
      param :path, :id, :integer, :required, "Artist ID"
    end

    def show
      artist = Artist.find(params[:id])
      render json: artist, only: [:id, :login, :password_digest, :nickname, :bio, :preferred_style], status: :ok
    end

    # POST /artists
    swagger_api :create do
      summary 'Creates an artist'
      param :body, :body, :string, :required, "Request body"
    end

    def create
      artist = Artist.new(artist_params)
      if artist.save
        render json: artist, only: [:id, :login, :password_digest, :nickname, :bio, :preferred_style], status: :created
      else
        render json: artist.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /artists/1
    swagger_api :update do
      summary 'Updates an artist\'s details'
      param :path, :id, :integer, :required, "Artist ID"
      param :body, :body, :string, :required, "Request body"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def update
      artist = Artist.find(params[:id])
      if artist.update(update_params)
        render json: artist, only: [:id, :login, :password_digest, :nickname, :bio, :preferred_style], status: :created
      else
        render json: artist.errors, status: :unprocessable_entity
      end
    end

    # DELETE /artists/1
    swagger_api :destroy do
      summary 'Deletes an artist'
      param :path, :id, :integer, :required, "Artist ID"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def destroy
      artist = Artist.find(params[:id])
      artist.destroy
      render json: { "success": "true" }, status: :ok
    end

    # GET /artists/1/orders
    swagger_api :list_orders do
      summary 'Returns artist\'s orders [EXPERIMENTAL FEATURE SHOWCASE]'
      param :path, :id, :integer, :required, "Artist ID"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def list_orders
      artist = Artist.find(params[:id])
      if @current_artist == artist || @current_artist == "admin" # EXPERIMENTAL Show orders only for token's owner, unless it's admin's token
        render json: artist, only: [:id, :login], include:
          [orders: { only: [:id, :order_status, :notes], include:
            [client: { only: [:id, :full_name, :email, :phone, :age] }, service: { only: [:id, :name], include:
              [category: { only: [:id, :name] }]
            }]
          }], status: :ok
      else
        render json: { "error": "You have no access to artist with 'id'=#{artist.id}" }, status: :forbidden
      end
    end

    private

    def artist_params
      params.permit(:login, :password, :password_confirmation, :nickname, :bio, :preferred_style)
    end

    def update_params
      params.permit(:password, :password_confirmation, :nickname, :bio, :preferred_style)
    end

    def not_found(error)
      render json: { "error": error.message }, status: :not_found
    end

    def foreign_key_block
      render json: { "error": "Foreign key in use" }, status: :internal_server_error
    end

    def not_null(error)
      render json: { "error": error.message }, status: :internal_server_error
    end

    def unauthorized(error)
      render json: { "error": error.message }, status: :unauthorized
    end
  end
end
