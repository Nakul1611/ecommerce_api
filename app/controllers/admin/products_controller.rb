module Admin
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]

    def index
      render json: Product.all
    end

    def show
      render json: @product
    end

    def create
      product = Product.new(product_params)
      if product.save
        render json: product, include: :variants, status: :created
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @product.update(product_params)
        render json: @product, include: :variants
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      head :no_content
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name, :description, :price, :category_id,
        variants_attributes: [
          :id, :sku, :price_override, :stock, :size, :color, :is_active, :_destroy
        ]
      )
    end
  end
end
