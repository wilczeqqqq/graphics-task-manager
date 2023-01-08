module V1
  class AddressesController < ApplicationController
    before_action :get_client
    before_action :authenticate_request, only: [:create, :destroy, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block
    rescue_from ActiveRecord::NotNullViolation, with: :not_null
    rescue_from JWT::DecodeError, with: :unauthorized

    swagger_controller :addresses, 'Addresses'

    # GET /clients/1/addresses
    swagger_api :index do
      summary 'Returns all addresses for a client'
      param :path, :client_id, :integer, :required, "Client ID"
    end

    def index
      addresses = @client.address
      render json: addresses, only: [:id, :address_line_1, :address_line_2, :postal_code, :city, :country], status: :ok
    end

    # GET /clients/1/addresses/1
    swagger_api :show do
      summary 'Returns an addresses for a client'
      param :path, :client_id, :integer, :required, "Client ID"
      param :path, :id, :integer, :required, "Address ID"
    end

    def show
      address = @client.address.find(params[:id])
      render json: address, only: [:id, :address_line_1, :address_line_2, :postal_code, :city, :country], status: :ok
    end

    # POST /clients/1/addresses
    swagger_api :create do
      summary 'Creates an address for a client'
      param :path, :client_id, :integer, :required, "Client ID"
      param :body, :body, :string, :required, "Request body"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def create
      address = @client.address.build(address_params)
      if address.save
        render json: address, only: [:id, :address_line_1, :address_line_2, :postal_code, :city, :country], include:
          [client: { only: [:id, :full_name, :email, :phone, :age] }], status: :created
      else
        render json: address.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /clients/1/addresses/1
    swagger_api :update do
      summary 'Updates an address for a client'
      param :path, :client_id, :integer, :required, "Client ID"
      param :path, :id, :integer, :required, "Address ID"
      param :body, :body, :string, :required, "Request body"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def update
      address = @client.address.find(params[:id])
      if address.update(address_params)
        render json: address, only: [:id, :address_line_1, :address_line_2, :postal_code, :city, :country], include:
          [client: { only: [:id, :full_name, :email, :phone, :age] }], status: :ok
      else
        render json: address.errors, status: :unprocessable_entity
      end
    end

    # DELETE /clients/1/addresses/1
    swagger_api :destroy do
      summary 'Deletes an address for a client'
      param :path, :client_id, :integer, :required, "Client ID"
      param :path, :id, :integer, :required, "Address ID"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def destroy
      address = @client.address.find(params[:id])
      address.destroy
      render json: { "success": "true" }, status: :ok
    end

    private

    def address_params
      params.permit(:client_id, :address_line_1, :address_line_2, :postal_code, :city, :country)
    end

    def update_params
      params.permit(:address_line_1, :address_line_2, :postal_code, :city, :country)
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

    def get_client
      @client = Client.find(params[:client_id])
    end

    def unauthorized(error)
      render json: { "error": error.message }, status: :unauthorized
    end
  end
end
