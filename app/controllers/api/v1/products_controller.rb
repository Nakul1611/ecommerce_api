module Api::V1
  class ProductsController < ApplicationController
    def index
      products = Product.all.includes(:category)
      render json: products, include: :category
    end

    def show
      product = Product.find(params[:id])
      render json: product, include: :category
    end

    def create
      product = Product.new(product_params)
      if product.save
        render json: product, status: :created
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def product_params
      params.require(:product).permit(:name, :description, :price, :category_id)
    end
  end
end
