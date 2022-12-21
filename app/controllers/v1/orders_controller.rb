module V1
  class OrdersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block

    # DONE

    # GET /orders or /orders.json
    def index
      orders = Order.all
      render json: orders, only: [:id, :order_status, :notes], include:
          [client: { only: [:id, :full_name, :email, :phone, :age] }, artist: { only: [:id, :nickname, :bio, :preferred_style] }, service: { only: [:id, :name], include:
            [category: { only: [:id, :name] }]
          }], status: :ok
    end

    # GET /orders/1 or /orders/1.json
    def show
      order = Order.find(params[:id])
      render json: order, only: [:id, :order_status, :notes], include:
        [client: { only: [:id, :full_name, :email, :phone, :age] }, artist: { only: [:id, :nickname, :bio, :preferred_style] }, service: { only: [:id, :name], include:
          [category: { only: [:id, :name] }]
        }], status: :ok
    end

    # POST /orders or /orders.json
    def create
      order = Order.new(order_params)
      order.order_status = "CREATED"
      if order.save
        render json: orders, only: [:id, :order_status, :notes], include:
          [client: { only: [:id, :full_name, :email, :phone, :age] }, artist: { only: [:id, :nickname, :bio, :preferred_style] }, service: { only: [:id, :name], include:
            [category: { only: [:id, :name] }]
          }], status: :created
      else
        render json: order.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /orders/1 or /orders/1.json
    def update
      order = Order.find(params[:id])
      if order.update(update_params)
        render json: order, only: [:id, :order_status], status: :ok
      else
        render json: order.errors, status: :unprocessable_entity
      end
    end

    # DELETE /orders/1 or /orders/1.json
    def destroy
      order = Order.find(params[:id])
      order.destroy
      render json: { "success": "true" }, status: :ok
    end

    private

    # Only allow a list of trusted parameters through.
    def order_params
      params.permit(:client_id, :artist_id, :service_id, :notes)
    end

    def update_params
      params.permit(:order_status)
    end

    def not_found
      render json: { "error": "not found" }, status: :not_found
    end

    def foreign_key_block
      render json: { "error": "foreign key in use" }, status: :internal_server_error
    end
  end
end
