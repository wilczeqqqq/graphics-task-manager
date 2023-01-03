module V1
  class CategoriesController < ApplicationController
    before_action :authenticate_request, only: [:create, :destroy, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block
    rescue_from JWT::DecodeError, with: :unauthorized

    # DONE

    # GET /categories
    def index
      categories = Category.all
      render json: categories, only: [:id, :name], status: :ok
    end

    # GET /categories/1
    def show
      category = Category.find(params[:id])
      render json: category, only: [:id, :name], status: :ok
    end

    # POST /categories
    def create
      category = Category.new(category_params)
      if category.save
        render json: category, only: [:id, :name], status: :created
      else
        render json: category.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /categories/1
    def update
      category = Category.find(params[:id])
      if category.update(category_params)
        render json: category, only: [:id, :name], status: :ok
      else
        render json: category.errors, status: :unprocessable_entity
      end
    end

    # DELETE /categories/1
    def destroy
      category = Category.find(params[:id])
      category.destroy
      render json: { "success": "true" }, status: :ok
    end

    # GET /categories/1/services
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
