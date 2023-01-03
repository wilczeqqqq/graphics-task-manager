module V1
  class ServicesController < ApplicationController
    before_action :authenticate_request, only: [:create, :destroy, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block
    rescue_from JWT::DecodeError, with: :unauthorized

    # DONE

    # GET /services
    def index
      services = Service.all
      render json: services, only: [:id, :name], include: { category: { only: [:id, :name] } }, status: :ok
    end

    # GET /services/1
    def show
      service = Service.find(params[:id])
      render json: service, only: [:id, :name], include: { category: { only: [:id, :name] } }, status: :ok
    end

    # POST /services
    def create
      service = Service.new(service_params)
      if service.save
        render json: service, only: [:id, :name, :category_id], status: :created
      else
        render json: service.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /services/1
    def update
      service = Service.find(params[:id])
      if service.update(service_params)
        render json: service, only: [:id, :name, :category_id], status: :ok
      else
        render json: service.errors, status: :unprocessable_entity
      end
    end

    # DELETE /services/1
    def destroy
      service = Service.find(params[:id])
      service.destroy
      render json: { "success": "true" }, status: :ok
    end

    private

    def service_params
      params.permit(:category_id, :name)
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