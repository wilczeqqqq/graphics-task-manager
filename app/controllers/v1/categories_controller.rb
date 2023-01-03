module V1
  class CategoriesController < ApplicationController
    before_action :authenticate_request, only: [:create, :destroy, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block
    rescue_from JWT::DecodeError, with: :unauthorized

    swagger_controller :categories, 'Categories'

    # GET /categories
    swagger_api :index do
      summary 'Returns all categories'
    end

    def index
      categories = Category.all
      render json: categories, only: [:id, :name], status: :ok
    end

    # GET /categories/1
    swagger_api :show do
      summary 'Returns a category'
      param :path, :id, :integer, :required, "Category ID"
    end

    def show
      category = Category.find(params[:id])
      render json: category, only: [:id, :name], status: :ok
    end

    # POST /categories
    swagger_api :create do
      summary 'Creates a category'
      param :body, :body, :string, :required, "Request body"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def create
      category = Category.new(category_params)
      if category.save
        render json: category, only: [:id, :name], status: :created
      else
        render json: category.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /categories/1
    swagger_api :update do
      summary 'Updates a category'
      param :path, :id, :integer, :required, "Category ID"
      param :body, :body, :string, :required, "Request body"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def update
      category = Category.find(params[:id])
      if category.update(category_params)
        render json: category, only: [:id, :name], status: :ok
      else
        render json: category.errors, status: :unprocessable_entity
      end
    end

    # DELETE /categories/1
    swagger_api :destroy do
      summary 'Deletes a category'
      param :path, :id, :integer, :required, "Category ID"
      param :header, :Authorization, :string, :required, "Authentication bearer token"
    end

    def destroy
      category = Category.find(params[:id])
      category.destroy
      render json: { "success": "true" }, status: :ok
    end

    # GET /categories/1/services
    swagger_api :list_services do
      summary 'Returns services for a category'
      param :path, :id, :integer, :required, "Category ID"
    end

    def list_services
      category = Category.find(params[:id])
      render json: category, only: [:id, :name], include: { services: { only: [:id, :name] } }, status: :ok
    end

    private

    def category_params
      params.permit(:name)
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
