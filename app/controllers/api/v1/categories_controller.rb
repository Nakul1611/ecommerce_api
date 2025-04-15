module Api::V1
  class CategoriesController < ApplicationController
    def index
      categories = Category.includes(:subcategories).where(parent_id: nil)
      render json: categories, include: :subcategories
    end

    def show
      category = Category.find(params[:id])
      render json: category, include: [:subcategories, :products]
    end

    def create
      category = Category.new(category_params)
      if category.save
        render json: category, status: :created
      else
        render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def category_params
      params.require(:category).permit(:name, :parent_id)
    end
  end
end
