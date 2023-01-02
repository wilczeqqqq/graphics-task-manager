module V1
  class AddressesController < ApplicationController
    before_action :get_client
    before_action :authenticate_request, only: [:create, :destroy, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block
    rescue_from JWT::DecodeError, with: :unauthorized

    # GET /addresses or /addresses.json
    def index
      addresses = @client.address
      render json: addresses, only: [:id, :address_line_1, :address_line_2, :postal_code, :city, :country], status: :ok
    end

    # GET /addresses/1 or /addresses/1.json
    def show
      address = @client.address.find(params[:id])
      render json: address, only: [:id, :address_line_1, :address_line_2, :postal_code, :city, :country], status: :ok
    end

    # POST /addresses or /addresses.json
    def create
      address = @client.address.build(address_params)
      if address.save
        render json: address, only: [:id, :address_line_1, :address_line_2, :postal_code, :city, :country], include:
              [client: { only: [:id, :full_name, :email, :phone, :age] }], status: :created
      else
        render json: address.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /addresses/1 or /addresses/1.json
    def update
      address = @client.address.find(params[:id])
      if address.update(address_params)
        render json: address, only: [:id, :address_line_1, :address_line_2, :postal_code, :city, :country], include:
              [client: { only: [:id, :full_name, :email, :phone, :age] }], status: :ok
      else
        render json: address.errors, status: :unprocessable_entity
      end
    end

    # DELETE /addresses/1 or /addresses/1.json
    def destroy
      address = @client.address.find(params[:id])
      address.destroy
      render json: { "success": "true" }, status: :ok
    end

    private

    # Only allow a list of trusted parameters through.
    def address_params
      params.permit(:client_id, :address_line_1, :address_line_2, :postal_code, :city, :country)
    end

    def update_params
      params.permit(:address_line_1, :address_line_2, :postal_code, :city, :country)
    end

    def not_found
      render json: { "error": "not found" }, status: :not_found
    end

    def foreign_key_block
      render json: { "error": "foreign key in use" }, status: :internal_server_error
    end

    def get_client
      @client = Client.find(params[:client_id])
    end

    def unauthorized
      render json: { "error": "unauthorized or token expired" }, status: :unauthorized
    end
  end
end
