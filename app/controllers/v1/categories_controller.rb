module V1
  class CategoriesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_block

    # DONE

    # GET /categories or /categories.json
    def index
      categories = Category.all
      render json: categories, only: [:id, :name], status: :ok
    end

    # GET /categories/1 or /categories/1.json
    def show
      category = Category.find(params[:id])
      render json: category, only: [:id, :name], status: :ok
    end

    # POST /categories or /categories.json
    def create
      category = Category.new(category_params)
      if category.save
        render json: category, only: [:id, :name], status: :created
      else
        render json: category.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /categories/1 or /categories/1.json
    def update
      category = Category.find(params[:id])
      if category.update(category_params)
        render json: category, only: [:id, :name], status: :ok
      else
        render json: category.errors, status: :unprocessable_entity
      end
    end

    # DELETE /categories/1 or /categories/1.json
    def destroy
      category = Category.find(params[:id])
      category.destroy
      render json: { "success": "true" }, status: :ok
    end

    def list_services
      category = Category.find(params[:id])
      render json: category, only: [:id, :name], include: { services: { only: [:id, :name] } }, status: :ok
    end

    private

    # Only allow a list of trusted parameters through.
    def category_params
      params.permit(:name)
    end

    def not_found
      render json: { "error": "not found" }, status: :not_found
    end

    def foreign_key_block
      render json: { "error": "foreign key in use" }, status: :internal_server_error
    end
  end
end
