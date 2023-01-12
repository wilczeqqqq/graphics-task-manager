module V1
  class ServicesController < ApplicationController
    before_action :authenticate_request, only: [:create, :destroy, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block
    rescue_from ActiveRecord::NotNullViolation, with: :not_null
    rescue_from JWT::DecodeError, with: :unauthorized

    swagger_controller :services, 'Services'

    # GET /services
    swagger_api :index do
      summary 'Returns all services'
    end

    def index
      services = Service.all
      render json: services, only: [:id, :name], include: { category: { only: [:id, :name] } }, status: :ok
    end

    # GET /services/1
    swagger_api :show do
      summary 'Returns a service'
      param :path, :id, :integer, :required, "Service ID"
    end

    def show
      service = Service.find(params[:id])
      render json: service, only: [:id, :name], include: { category: { only: [:id, :name] } }, status: :ok
    end

    # POST /services
    swagger_api :create do
      summary 'Creates a service'
      param :body, :body, :string, :required, "Request body"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def create
      service = Service.new(service_params)
      if service.save
        render json: service, only: [:id, :name], include: { category: { only: [:id, :name] } }, status: :created
      else
        render json: service.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /services/1
    swagger_api :update do
      summary 'Updates a service'
      param :path, :id, :integer, :required, "Service ID"
      param :body, :body, :string, :required, "Request body"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def update
      service = Service.find(params[:id])
      if service.update(service_params)
        render json: service, only: [:id, :name, :category_id], status: :ok
      else
        render json: service.errors, status: :unprocessable_entity
      end
    end

    # DELETE /services/1
    swagger_api :destroy do
      summary 'Deletes a service'
      param :path, :id, :integer, :required, "Service ID"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def destroy
      service = Service.find(params[:id])
      service.destroy
      render json: { "success": "true" }, status: :ok
    end

    private

    def service_params
      params.permit(:category_id, :name)
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