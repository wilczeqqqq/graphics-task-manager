module V1
  class OrdersController < ApplicationController
    before_action :authenticate_request, only: [:create, :destroy, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block
    rescue_from ActiveRecord::NotNullViolation, with: :not_null
    rescue_from JWT::DecodeError, with: :unauthorized

    swagger_controller :orders, 'Orders'

    # GET /orders
    swagger_api :index do
      summary 'Returns all orders'
    end

    def index
      orders = Order.all
      render json: orders, only: [:id, :order_status, :notes], include:
        [client: { only: [:id, :full_name, :email, :phone, :age] }, artist: { only: [:id, :nickname, :bio, :preferred_style] }, service: { only: [:id, :name], include:
          [category: { only: [:id, :name] }]
        }], status: :ok
    end

    # GET /orders/1
    swagger_api :show do
      summary 'Returns an order'
      param :path, :id, :integer, :required, "Order ID"
    end

    def show
      order = Order.find(params[:id])
      render json: order, only: [:id, :order_status, :notes], include:
        [client: { only: [:id, :full_name, :email, :phone, :age] }, artist: { only: [:id, :nickname, :bio, :preferred_style] }, service: { only: [:id, :name], include:
          [category: { only: [:id, :name] }]
        }], status: :ok
    end

    # POST /orders
    swagger_api :create do
      summary 'Creates an order'
      param :body, :body, :string, :required, "Request body"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def create
      order = Order.new(order_params)
      order.order_status = "CREATED"
      if order.save
        render json: order, only: [:id, :order_status, :notes], include:
          [client: { only: [:id, :full_name, :email, :phone, :age] }, artist: { only: [:id, :nickname, :bio, :preferred_style] }, service: { only: [:id, :name], include:
            [category: { only: [:id, :name] }]
          }], status: :created
      else
        render json: order.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /orders/1
    swagger_api :update do
      summary 'Updates an order status'
      param :path, :id, :integer, :required, "Order ID"
      param :body, :body, :string, :required, "Request body"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def update
      order = Order.find(params[:id])
      if order.update(update_params)
        render json: order, only: [:id, :order_status], status: :ok
      else
        render json: order.errors, status: :unprocessable_entity
      end
    end

    # DELETE /orders/1
    swagger_api :destroy do
      summary 'Deletes an order'
      param :path, :id, :integer, :required, "Order ID"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def destroy
      order = Order.find(params[:id])
      order.destroy
      render json: { "success": "true" }, status: :ok
    end

    private

    def order_params
      params.permit(:client_id, :artist_id, :service_id, :notes)
    end

    def update_params
      params.permit(:order_status)
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
