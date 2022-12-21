module V1
  class ClientsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block

    # DONE

    # GET /clients or /clients.json
    def index
      clients = Client.all
      render json: clients, only: [:id, :full_name, :email, :phone, :age], status: :ok
    end

    # GET /clients/1 or /clients/1.json
    def show
      client = Client.find(params[:id])
      render json: client, only: [:id, :full_name, :email, :phone, :age], status: :ok
    end

    # POST /clients or /clients.json
    def create
      client = Client.new(client_params)
      if client.save
        render json: client, only: [:id, :full_name, :email, :phone, :age], status: :created
      else
        render json: client.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /clients/1 or /clients/1.json
    def update
      client = Client.find(params[:id])
      if client.update(client_params)
        render json: client, only: [:id, :full_name, :email, :phone, :age], status: :ok
      else
        render json: client.errors, status: :unprocessable_entity
      end
    end

    # DELETE /clients/1 or /clients/1.json
    def destroy
      client = Client.find(params[:id])
      client.destroy
      render json: { "success": "true" }, status: :ok
    end

    def list_orders
      client = Client.find(params[:id])
      render json: client, only: [:id, :full_name], include:
        [orders: { only: [:id, :order_status, :notes], include:
          [artist: { only: [:id, :nickname, :bio, :preferred_style] }, service: { only: [:id, :name], include:
            [category: { only: [:id, :name] }]
          }]
        }], status: :ok
    end

    private

    # Only allow a list of trusted parameters through.
    def client_params
      params.permit(:full_name, :email, :phone, :age)
    end

    def not_found
      render json: { "error": "not found" }, status: :not_found
    end

    def foreign_key_block
      render json: { "error": "foreign key in use" }, status: :internal_server_error
    end
  end
end
